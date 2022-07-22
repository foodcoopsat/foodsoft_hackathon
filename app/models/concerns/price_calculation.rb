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

    related_ratio = self.article_unit_ratios.detect { |current_ratio| ArticleUnits.units[current_ratio.unit][:baseUnit] == ArticleUnits.units[unit][:baseUnit] }
    unless related_ratio.nil?
      return related_ratio.quantity / ArticleUnits.units[unit][:conversionFactor] * ArticleUnits.units[related_ratio.unit][:conversionFactor]
    end

    ArticleUnits.units[self.supplier_order_unit][:conversionFactor] / ArticleUnits.units[unit][:conversionFactor]
  end

  def convert_quantity(quantity, input_unit, output_unit)
    quantity / self.get_unit_ratio_quantity(input_unit) * self.get_unit_ratio_quantity(output_unit)
  end

  def get_price(output_unit, type = :net)
    price_value = (type == :gross ? self.gross_price : self.price)
    price_value / self.get_unit_ratio_quantity(output_unit) * self.get_unit_ratio_quantity(self.price_unit)
  end

  private

  def add_percent(value, percent)
    (value * (percent * 0.01 + 1)).round(2)
  end
end
