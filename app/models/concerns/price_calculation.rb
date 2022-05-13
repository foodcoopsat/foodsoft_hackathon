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

  def get_unit_ratio_quantity(unit)
    return 1 if unit == self.supplier_order_unit

    self.article_unit_ratios.find_by_unit(unit).quantity
  end

  def convert_quantity(quantity, input_unit, output_unit)
    quantity / self.get_unit_ratio_quantity(input_unit) * self.get_unit_ratio_quantity(output_unit)
  end

  def get_price(output_unit)
    self.price / self.get_unit_ratio_quantity(output_unit) * self.get_unit_ratio_quantity(self.price_unit)
  end

  private

  def add_percent(value, percent)
    (value * (percent * 0.01 + 1)).round(2)
  end
end
