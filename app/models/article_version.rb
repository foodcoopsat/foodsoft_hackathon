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

  has_many :article_unit_ratios, after_add: :on_article_unit_ratios_change, after_remove: :on_article_unit_ratios_change, dependent: :destroy

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
  validates_numericality_of :minimum_order_quantity, allow_nil: true, only_integer: false, if: :supplier_order_unit_is_si_convertible
  validates_numericality_of :minimum_order_quantity, allow_nil: true, only_integer: true, unless: :supplier_order_unit_is_si_convertible
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

  def supplier_order_unit_is_si_convertible
    ArticleUnitsLib.unit_is_si_convertible(self.supplier_order_unit)
  end

  # TODO: Maybe use the nilify blanks gem instead of the following six methods?:
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

  def minimum_order_quantity=(value)
    if value.blank?
      self[:minimum_order_quantity] = nil
    else
      super
    end
  end

  def self_or_ratios_changed?
    changed? || @article_unit_ratios_changed || article_unit_ratios.any?(&:changed?)
  end

  def duplicate_including_article_unit_ratios
    new_version = self.dup
    self.article_unit_ratios.each do |ratio|
      ratio = ratio.dup
      ratio.article_version_id = nil
      new_version.article_unit_ratios << ratio
    end

    new_version
  end

  # Compare attributes from two different articles.
  #
  # This is used for auto-synchronization
  # @param attributes [Hash<Symbol, Array>] Attributes with old and new values
  # @return [Hash<Symbol, Object>] Changed attributes with new values
  def self.compare_attributes(attributes)
    unequal_attributes = attributes.select { |_name, values| values[0] != values[1] && !(values[0].blank? && values[1].blank?) }
    unequal_attributes.to_a.map { |a| [a[0], a[1].last] }.to_h
  end

  protected

  # We used have the name unique per supplier+deleted_at+type. With the addition of shared_sync_method all,
  # this came in the way, and we now allow duplicate names for the 'all' methods - expecting foodcoops to
  # make their own choice among products with different units by making articles available/unavailable.
  def uniqueness_of_name
    matches = Article.includes(latest_article_version: :article_unit_ratios).where(article_versions: { name: name }, supplier_id: article.supplier_id, deleted_at: article.deleted_at, type: article.type)
    matches = matches.where.not(id: article.id) unless article.new_record?
    # supplier should always be there - except, perhaps, on initialization (on seeding)
    if article.supplier && (article.supplier.shared_sync_method.blank? || article.supplier.shared_sync_method == 'import')
      errors.add :name, :taken if matches.any?
    elsif matches.where(article_versions: { unit: unit, supplier_order_unit: nil, article_unit_ratios: { quantity: unit_quantity, unit: 'XPP' } }).any?
      errors.add :name, :taken_with_unit
    end
  end

  def only_one_unit_type
    unless unit.blank? || supplier_order_unit.blank?
      errors.add :unit # not specifying a specific error message as this should be prevented by js
    end
  end

  def on_article_unit_ratios_change(_some_change)
    @article_unit_ratios_changed = true
  end
end
