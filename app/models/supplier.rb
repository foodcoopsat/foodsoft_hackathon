require 'net/http'

class Supplier < ApplicationRecord
  include MarkAsDeletedWithName
  include CustomFields

  has_many :articles, -> { merge(Article.with_latest_versions_and_categories.order('article_categories.name, article_versions.name')) }
  has_many :stock_articles, -> { merge(StockArticle.with_latest_versions_and_categories.order('article_categories.name, article_versions.name')) }
  has_many :orders
  has_many :deliveries
  has_many :invoices
  belongs_to :supplier_category

  validates :name, :presence => true, :length => { :in => 4..30 }
  validates :phone, :presence => true, :length => { :in => 8..25 }
  validates :address, :presence => true, :length => { :in => 8..50 }
  validates_format_of :iban, :with => /\A[A-Z]{2}[0-9]{2}[0-9A-Z]{,30}\z/, :allow_blank => true
  validates_uniqueness_of :iban, :case_sensitive => false, :allow_blank => true
  validates_length_of :order_howto, :note, maximum: 250
  validate :uniqueness_of_name
  validates :shared_sync_method, presence: true, unless: -> { supplier_remote_source.blank? }
  validates :shared_sync_method, absence: true, if: -> { supplier_remote_source.blank? }

  enum shared_sync_method: { :all_available => 'all_available', :all_unavailable => 'all_unavailable', :import => 'import' }

  scope :undeleted, -> { where(deleted_at: nil) }
  scope :having_articles, -> { where(id: Article.undeleted.select(:supplier_id).distinct) }

  def self.ransackable_attributes(auth_object = nil)
    %w(id name)
  end

  def self.ransackable_associations(auth_object = nil)
    %w(articles stock_articles orders)
  end

  # sync all articles with the external database
  # returns an array with articles(and prices), which should be updated (to use in a form)
  # also returns an array with outlisted_articles, which should be deleted
  # also returns an array with new articles, which should be added (depending on shared_sync_method)
  def sync_all
    updated_article_pairs, outlisted_articles, new_articles = [], [], []
    existing_articles = Set.new
    for article in articles.undeleted
      # try to find the associated shared_article
      shared_article = article.shared_article(self)

      if shared_article # article will be updated
        existing_articles.add(shared_article.id)
        unequal_attributes = article.shared_article_changed?(self)
        unless unequal_attributes.blank? # skip if shared_article has not been changed
          if unequal_attributes.key?(:article_unit_ratios_attributes)
            article.latest_article_version.article_unit_ratios.each(&:delete)
          end
          article.latest_article_version.reload
          article.latest_article_version.attributes = unequal_attributes
          updated_article_pairs << [article, unequal_attributes]
        end
      # Articles with no order number can be used to put non-shared articles
      # in a shared supplier, with sync keeping them.
      elsif not article.order_number.blank?
        # article isn't in external database anymore
        outlisted_articles << article
      end
    end
    # Find any new articles, unless the import is manual
    if ['all_available', 'all_unavailable'].include?(shared_sync_method)
      # build new articles
      shared_supplier
        .shared_articles
        .where.not(id: existing_articles.to_a)
        .find_each { |new_shared_article| new_articles << new_shared_article.build_new_article(self) }
      # make them unavailable when desired
      if shared_sync_method == 'all_unavailable'
        new_articles.each { |new_article| new_article.latest_article_version.availability = false }
      end
    end
    return [updated_article_pairs, outlisted_articles, new_articles]
  end

  # Synchronise articles with spreadsheet.
  #
  # @param file [File] Spreadsheet file to parse
  # @param options [Hash] Options passed to {FoodsoftFile#parse} except when listed here.
  # @option options [Boolean] :outlist_absent Set to +true+ to remove articles not in spreadsheet.
  # @option options [Boolean] :convert_units Omit or set to +true+ to keep current units, recomputing unit quantity and price.
  def sync_from_file(file, options = {})
    data = FoodsoftFile::parse(file, options)
    self.parse_import_data({ articles: data }, options)
  end

  def read_from_remote(search_params = {})
    url = URI(self.supplier_remote_source)
    url.query = URI.encode_www_form(search_params) unless search_params.nil?
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = url.scheme == 'https'
    request = Net::HTTP::Get.new(url)

    response = http.request(request)
    JSON.parse(response.body, symbolize_names: true)
  end

  def sync_from_remote(options = {})
    data = read_from_remote(options[:search_params])
    self.parse_import_data(data, options)
  end

  def deleted?
    deleted_at.present?
  end

  def mark_as_deleted
    transaction do
      super
      update_column :iban, nil
      articles.each(&:mark_as_deleted)
    end
  end

  # @return [Boolean] Whether there are articles that would use tolerance (unit_quantity > 1)
  def has_tolerance?
    articles.where('articles.unit_quantity > 1').any?
  end

  # TODO: Maybe use the nilify blanks gem instead of the following two methods?:
  def supplier_remote_source=(value)
    if value.blank?
      self[:supplier_remote_source] = nil
    else
      super
    end
  end

  def shared_sync_method=(value)
    if value.blank?
      self[:shared_sync_method] = nil
    else
      super
    end
  end

  protected

  # Make sure, the name is uniq, add usefull message if uniq group is already deleted
  def uniqueness_of_name
    supplier = Supplier.where(name: name)
    supplier = supplier.where.not(id: self.id) unless new_record?
    if supplier.exists?
      message = supplier.first.deleted? ? :taken_with_deleted : :taken
      errors.add :name, message
    end
  end

  def parse_import_data(data, options = {})
    all_order_numbers = []
    updated_article_pairs, outlisted_articles, new_articles = [], [], []

    data[:articles].each do |new_attrs|
      article = articles.includes(:latest_article_version).undeleted.where(article_versions: { order_number: new_attrs[:order_number] }).first
      new_attrs[:article_category] = ArticleCategory.find_match(new_attrs[:article_category])
      new_attrs[:tax] ||= FoodsoftConfig[:tax_default]
      new_attrs[:article_unit_ratios] = new_attrs[:article_unit_ratios].map { |ratio_hash| ArticleUnitRatio.new(ratio_hash) }
      new_article = articles.build
      new_article_version = new_article.article_versions.build(new_attrs)
      new_article.article_versions << new_article_version
      new_article.latest_article_version = new_article_version

      if new_attrs[:availability]
        if article.nil?
          new_articles << new_article
        else
          unequal_attributes = article.unequal_attributes(new_article, options.slice(:convert_units))
          unless unequal_attributes.empty?
            article.latest_article_version.article_unit_ratios.target.clear unless unequal_attributes[:article_unit_ratios_attributes].nil?
            article.latest_article_version.attributes = unequal_attributes
            duped_ratios = article.latest_article_version.article_unit_ratios.map(&:dup)
            article.latest_article_version.article_unit_ratios.target.clear
            article.latest_article_version.article_unit_ratios.target.push(*duped_ratios)
            updated_article_pairs << [article, unequal_attributes]
          end
        end
      elsif article.present?
        outlisted_articles << article
      end
      all_order_numbers << article.order_number if article
    end
    if options[:outlist_absent]
      outlisted_articles += articles.includes(:latest_article_version).undeleted.where.not(article_versions: { order_number: all_order_numbers + [nil] })
    end
    return [updated_article_pairs, outlisted_articles, new_articles]
  end
end
