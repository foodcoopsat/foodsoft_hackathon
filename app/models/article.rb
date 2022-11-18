class Article < ApplicationRecord
  include PriceCalculation

  # @!attribute name
  #   @return [String] Article name
  # @!attribute unit
  #   @return [String] Unit, e.g. +kg+, +2 L+ or +5 pieces+.
  # @!attribute note
  #   @return [String] Short line with optional extra article information.
  # @!attribute availability
  #   @return [Boolean] Whether this article is available within the Foodcoop.
  # @!attribute manufacturer
  #   @return [String] Original manufacturer.
  # @!attribute origin
  #   Where the article was produced.
  #   ISO 3166-1 2-letter country code, optionally prefixed with region.
  #   E.g. +NL+ or +Sicily, IT+ or +Berlin, DE+.
  #   @return [String] Production origin.
  #   @see http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2#Officially_assigned_code_elements
  # @!attribute price
  #   @return [Number] Net price
  #   @see ArticleVersion#price
  # @!attribute tax
  #   @return [Number] VAT percentage (10 is 10%).
  #   @see ArticleVersion#tax
  # @!attribute deposit
  #   @return [Number] Deposit
  #   @see ArticleVersion#deposit
  # @!attribute unit_quantity
  #   @return [Number] Number of units in wholesale package (box).
  #   @see ArticleVersion#unit_quantity
  # @!attribute order_number
  # Order number, this can be used by the supplier to identify articles.
  # This is required when using the shared database functionality.
  #   @return [String] Order number.
  # @!attribute article_category
  #   @return [ArticleCategory] Category this article is in.
  # @!attribute supplier
  #   @return [Supplier] Supplier this article belongs to.
  belongs_to :supplier
  # @!attribute article_versions
  #   @return [Array<ArticleVersion>] Price history (current price first).
  has_many :article_versions, -> { order("created_at DESC") }
  # @!attribute order_articles
  #   @return [Array<OrderArticle>] Order articles for this article.
  has_many :order_articles
  # @!attribute order
  #   @return [Array<Order>] Orders this article appears in.
  has_many :orders, through: :order_articles

  has_one :latest_article_version, -> { merge(ArticleVersion.latest) }, foreign_key: :article_id, class_name: :ArticleVersion

  scope :undeleted, -> { where(deleted_at: nil) }
  scope :available, -> { undeleted.with_latest_versions_and_categories.where(article_versions: { availability: true }) }
  scope :not_in_stock, -> { where(type: nil) }

  scope :with_latest_versions_and_categories, lambda {
                                                includes(:latest_article_version)
                                                  .joins(article_versions: [:article_category])
                                                  .joins(ArticleVersion.latest_outer_join_sql("#{table_name}.#{primary_key}"))
                                                  .where(later_article_versions: { id: nil })
                                              }

  accepts_nested_attributes_for :latest_article_version

  # TODO-article-version: Discuss if these delegates aren't actually a code smell:
  ArticleVersion.column_names.each do |column_name|
    next if column_name == ArticleVersion.primary_key

    delegate column_name, to: :latest_article_version, allow_nil: true
  end

  delegate :article_category, to: :latest_article_version, allow_nil: true
  delegate :article_unit_ratios, to: :latest_article_version, allow_nil: true

  # Callbacks
  before_save :update_or_create_article_version
  before_destroy :check_article_in_use
  after_save :reload_article_on_version_change

  def self.ransackable_attributes(auth_object = nil)
    # TODO-article-version
    %w(id name supplier_id article_category_id unit note manufacturer origin unit_quantity order_number)
  end

  def self.ransackable_associations(auth_object = nil)
    # TODO-article-version
    %w(article_category supplier order_articles orders)
  end

  # Returns true if article has been updated at least 2 days ago
  def recently_updated
    latest_article_version.updated_at > 2.days.ago
  end

  # If the article is used in an open Order, the Order will be returned.
  def in_open_order
    @in_open_order ||= begin
      order_articles = OrderArticle.where(order_id: Order.open.collect(&:id))
      # TODO-article-version:
      order_article = order_articles.detect { |oa| oa.article_id == id }
      order_article ? order_article.order : nil
    end
  end

  # Returns true if the article has been ordered in the given order at least once
  def ordered_in_order?(order)
    order.order_articles.where(article_id: id).where('quantity > 0').one?
  end

  # this method checks, if the shared_article has been changed
  # unequal attributes will returned in array
  # if only the timestamps differ and the attributes are equal,
  # false will returned and self.shared_updated_on will be updated
  def shared_article_changed?(supplier = self.supplier)
    # skip early if the timestamp hasn't changed
    shared_article = self.shared_article(supplier)
    unless shared_article.nil? || self.shared_updated_on == shared_article.updated_on
      attrs = unequal_attributes(shared_article)
      if attrs.empty?
        # when attributes not changed, update timestamp of article
        self.update_attribute(:shared_updated_on, shared_article.updated_on)
        false
      else
        attrs
      end
    end
  end

  # Return article attributes that were changed (incl. unit conversion)
  # @param new_article [Article] New article to update self
  # @option options [Boolean] :convert_units Omit or set to +true+ to keep current unit and recompute unit quantity and price.
  # @return [Hash<Symbol, Object>] Attributes with new values
  def unequal_attributes(new_article, options = {})
    # try to convert different units when desired
    if options[:convert_units] == false
      new_price, new_unit_quantity = nil, nil
    else
      new_price, new_unit_quantity = convert_units(new_article)
    end
    if new_price && new_unit_quantity
      new_unit = self.unit
    else
      new_price = new_article.price
      new_unit_quantity = new_article.unit_quantity
      new_unit = new_article.unit
    end

    return Article.compare_attributes(
      {
        :name => [self.name, new_article.name],
        :manufacturer => [self.manufacturer, new_article.manufacturer.to_s],
        :origin => [self.origin, new_article.origin],
        :unit => [self.unit, new_unit],
        :price => [self.price.to_f.round(2), new_price.to_f.round(2)],
        :tax => [self.tax, new_article.tax],
        :deposit => [self.deposit.to_f.round(2), new_article.deposit.to_f.round(2)],
        # take care of different num-objects.
        :unit_quantity => [self.unit_quantity.to_s.to_f, new_unit_quantity.to_s.to_f],
        :note => [self.note.to_s, new_article.note.to_s]
      }
    )
  end

  # Compare attributes from two different articles.
  #
  # This is used for auto-synchronization
  # @param attributes [Hash<Symbol, Array>] Attributes with old and new values
  # @return [Hash<Symbol, Object>] Changed attributes with new values
  def self.compare_attributes(attributes)
    unequal_attributes = attributes.select { |name, values| values[0] != values[1] && !(values[0].blank? && values[1].blank?) }
    Hash[unequal_attributes.to_a.map { |a| [a[0], a[1].last] }]
  end

  # to get the correspondent shared article
  def shared_article(supplier = self.supplier)
    self.order_number.blank? and return nil
    @shared_article ||= supplier.shared_supplier.find_article_by_number(self.order_number) rescue nil
  end

  # convert units in foodcoop-size
  # uses unit factors in app_config.yml to calc the price/unit_quantity
  # returns new price and unit_quantity in array, when calc is possible => [price, unit_quanity]
  # returns false if units aren't foodsoft-compatible
  # returns nil if units are eqal
  def convert_units(new_article = shared_article)
    if unit != new_article.unit
      # legacy, used by foodcoops in Germany
      if new_article.unit == "KI" && unit == "ST" # 'KI' means a box, with a different amount of items in it
        # try to match the size out of its name, e.g. "banana 10-12 St" => 10
        new_unit_quantity = /[0-9\-\s]+(St)/.match(new_article.name).to_s.to_i
        if new_unit_quantity && new_unit_quantity > 0
          new_price = (new_article.price / new_unit_quantity.to_f).round(2)
          [new_price, new_unit_quantity]
        else
          false
        end
      else # use ruby-units to convert
        fc_unit = (::Unit.new(unit) rescue nil)
        supplier_unit = (::Unit.new(new_article.unit) rescue nil)
        if fc_unit && supplier_unit && fc_unit =~ supplier_unit
          conversion_factor = (supplier_unit / fc_unit).to_base.to_r
          new_price = new_article.price / conversion_factor
          new_unit_quantity = new_article.unit_quantity * conversion_factor
          [new_price, new_unit_quantity]
        else
          false
        end
      end
    else
      nil
    end
  end

  def deleted?
    deleted_at.present?
  end

  def mark_as_deleted
    check_article_in_use
    update_column :deleted_at, Time.now
  end

  protected

  # Checks if the article is in use before it will deleted
  def check_article_in_use
    raise I18n.t('articles.model.error_in_use', :article => self.name.to_s) if self.in_open_order
  end

  # Create an ArticleVersion, when the price-attr are changed.
  def update_or_create_article_version
    @version_changed_before_save = false
    return unless self.version_dup_required?

    old_version = self.latest_article_version
    new_version = old_version.dup
    self.article_versions << new_version

    self.article_unit_ratios.each do |ratio|
      ratio = ratio.dup
      ratio.article_version_id = nil
      new_version.article_unit_ratios << ratio
    end
    OrderArticle.belonging_to_open_order.where(article_version_id: self.id).update_all(article_version_id: new_version.id)

    # reload old version to avoid updating it too (would automatically happen after before_save):
    old_version.reload

    @version_changed_before_save = true
  end

  def reload_article_on_version_change
    self.reload if @version_changed_before_save
    @version_changed_before_save = false
  end

  def version_dup_required?
    return false if latest_article_version.nil?
    return false unless latest_article_version.self_or_ratios_changed?

    OrderArticle.belonging_to_finished_order.exists?(article_version_id: latest_article_version.id)
  end
end
