module PriceCalculation
  extend ActiveSupport::Concern

  def unit_quantity
    first_ratio = article_unit_ratios.first
    if first_ratio.nil?
      1
    else
      first_ratio.quantity
    end
  end

  # Gross price = net price + deposit + tax.
  # @return [Number] Gross price.
  def gross_price
    add_percent(price + deposit, tax)
  end

  # @return [Number] Price for the foodcoop-member.
  def fc_price
    add_percent(gross_price, FoodsoftConfig[:price_markup])
  end

  # get the unit ratio quantity in reference to the supplier_order_unit
  def get_unit_ratio_quantity(unit)
    return 1 if unit == self.supplier_order_unit

    ratio = self.article_unit_ratios.find_by_unit(unit)
    return ratio.quantity unless ratio.nil?

    related_ratio = self.article_unit_ratios.detect { |current_ratio| ArticleUnit.as_hash[current_ratio.unit][:baseUnit] == ArticleUnit.as_hash[unit][:baseUnit] }
    unless related_ratio.nil?
      return related_ratio.quantity / ArticleUnit.as_hash[unit][:conversionFactor] * ArticleUnit.as_hash[related_ratio.unit][:conversionFactor]
    end

    ArticleUnit.as_hash[self.supplier_order_unit][:conversionFactor] / ArticleUnit.as_hash[unit][:conversionFactor]
  end

  def convert_quantity(quantity, input_unit, output_unit)
    quantity / self.get_unit_ratio_quantity(input_unit) * self.get_unit_ratio_quantity(output_unit)
  end

  def group_order_price(value = nil)
    value ||= price
    value / convert_quantity(1, supplier_order_unit, group_order_unit)
  end

  def gross_group_order_price
    group_order_price(gross_price)
  end

  def fc_group_order_price
    group_order_price(fc_price)
  end

  private

  def add_percent(value, percent)
    (value * (percent * 0.01 + 1)).round(2)
  end
end
