class ArticleVersion < ApplicationRecord
  include PriceCalculation

  # @!attribute price
  #   @return [Number] Net price
  #   @see Article#price
  # @!attribute tax
  #   @return [Number] VAT percentage
  #   @see Article#tax
  # @!attribute deposit
  #   @return [Number] Deposit
  #   @see Article#deposit
  # @!attribute unit_quantity
  #   @return [Number] Number of units in wholesale package (box).
  #   @see Article#unit
  #   @see Article#unit_quantity
  # @!attribute article
  #   @return [Article] Article this price is about.
  belongs_to :article
  belongs_to :article_category
  # @!attribute order_articles
  #   @return [Array<OrderArticle>] Order articles this price is associated with.
  has_many :order_articles

  has_many :article_unit_ratios

  localize_input_of :price, :tax, :deposit

  # Validations
  validates_presence_of :name, :price, :tax, :deposit, :article_category
  validates_length_of :name, :in => 4..60
  validates_length_of :unit, :in => 1..15, :unless => :supplier_order_unit
  validates_presence_of :supplier_order_unit, :unless => :unit
  validates_length_of :note, :maximum => 255
  validates_length_of :origin, :maximum => 255
  validates_length_of :manufacturer, :maximum => 255
  validates_length_of :order_number, :maximum => 255
  validates_numericality_of :price, :greater_than_or_equal_to => 0
  validates_numericality_of :deposit, :tax
  # validates_uniqueness_of :name, :scope => [:supplier_id, :deleted_at, :type], if: Proc.new {|a| a.supplier.shared_sync_method.blank? or a.supplier.shared_sync_method == 'import' }
  # validates_uniqueness_of :name, :scope => [:supplier_id, :deleted_at, :type, :unit, :unit_quantity]
  validate :uniqueness_of_name
  validate :only_one_unit_type

  # Replace numeric seperator with database format
  localize_input_of :price, :tax, :deposit
  # Get rid of unwanted whitespace. {Unit#new} may even bork on whitespace.
  normalize_attributes :name, :unit, :note, :manufacturer, :origin, :order_number

  accepts_nested_attributes_for :article_unit_ratios, allow_destroy: true

  scope :latest, lambda {
    joins(latest_outer_join_sql("#{table_name}.article_id")).where(later_article_versions: { id: nil })
  }

  def self.latest_outer_join_sql(article_field_name)
    %{
      LEFT OUTER JOIN article_versions later_article_versions
      ON later_article_versions.article_id = #{article_field_name}
        AND later_article_versions.created_at > article_versions.created_at
    }
  end

  # TODO: Maybe use the nilify blanks gem instead of the following five methods?:
  def unit=(value)
    if value.blank?
      self[:unit] = nil
    else
      super
    end
  end

  def supplier_order_unit=(value)
    if value.blank?
      self[:supplier_order_unit] = nil
    else
      super
    end
  end

  def group_order_unit=(value)
    if value.blank?
      self[:group_order_unit] = nil
    else
      super
    end
  end

  def price_unit=(value)
    if value.blank?
      self[:price_unit] = nil
    else
      super
    end
  end

  def billing_unit=(value)
    if value.blank?
      self[:billing_unit] = nil
    else
      super
    end
  end

  protected

  # We used have the name unique per supplier+deleted_at+type. With the addition of shared_sync_method all,
  # this came in the way, and we now allow duplicate names for the 'all' methods - expecting foodcoops to
  # make their own choice among products with different units by making articles available/unavailable.
  def uniqueness_of_name
    # TODO-article-version
    # matches = Article.where(name: name, supplier_id: supplier_id, deleted_at: deleted_at, type: type)
    # matches = matches.where.not(id: id) unless new_record?
    # # supplier should always be there - except, perhaps, on initialization (on seeding)
    # if supplier && (supplier.shared_sync_method.blank? || supplier.shared_sync_method == 'import')
    #   errors.add :name, :taken if matches.any?
    # else
    #   errors.add :name, :taken_with_unit if matches.where(unit: unit, unit_quantity: unit_quantity).any?
    # end
  end

  def only_one_unit_type
    unless unit.blank? || supplier_order_unit.blank?
      errors.add :unit # not specifying a specific error message as this should be prevented by js
    end
  end
end
