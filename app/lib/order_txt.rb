class OrderTxt
  include ActionView::Helpers::NumberHelper
  include ArticlesHelper
  include OrdersHelper

  def initialize(order, _options = {})
    @order = order
  end

  # Renders the fax-text-file
  # e.g. for easier use with online-fax-software, which don't accept pdf-files
  def to_txt
    supplier = @order.supplier
    contact = FoodsoftConfig[:contact].symbolize_keys
    text = I18n.t('orders.fax.heading', name: FoodsoftConfig[:name])
    text += "\n#{Supplier.human_attribute_name(:customer_number)}: #{supplier.customer_number}" if supplier.customer_number.present?
    text += "\n" + I18n.t('orders.fax.delivery_day')
    text += "\n\n#{supplier.name}\n#{supplier.address}\n#{Supplier.human_attribute_name(:fax)}: #{supplier.fax}\n\n"
    text += '****** ' + I18n.t('orders.fax.to_address') + "\n\n"
    text += "#{FoodsoftConfig[:name]}\n#{contact[:street]}\n#{contact[:zip_code]} #{contact[:city]}\n\n"
    text += '****** ' + I18n.t('orders.fax.articles') + "\n\n"

    # prepare order_articles data
    longest_number_string_length = 0
    longest_amount_string_length = I18n.t('orders.fax.amount').length
    longest_unit_string_length = I18n.t('orders.fax.unit').length
    @order_positions = @order.order_articles.ordered.includes(:article_version).map do |oa|
      number = oa.article_version.order_number || ''
      amount = format_units_to_order(oa).to_s
      unit = format_supplier_order_unit_with_ratios(oa.price)
      longest_number_string_length = number.length if number.length > longest_number_string_length
      longest_amount_string_length = amount.length if amount.length > longest_amount_string_length
      longest_unit_string_length = unit.length if unit.length > longest_unit_string_length
      {
        number: number,
        amount: amount,
        unit: unit,
        name: oa.article_version.name
      }
    end

    if (any_number_present = longest_number_string_length > 0) && longest_number_string_length < I18n.t('orders.fax.number').length
      longest_number_string_length = I18n.t('orders.fax.number').length
    end

    # header for order articles table
    text += format('%s  ', I18n.t('orders.fax.number').ljust(longest_number_string_length)) if any_number_present
    text += format("%s %s  %s\n", I18n.t('orders.fax.amount').rjust(longest_amount_string_length),
                   I18n.t('orders.fax.unit').ljust(longest_unit_string_length), I18n.t('orders.fax.name'))

    # now display all ordered articles
    @order_positions.each do |op|
      text += format('%s  ', op[:number].ljust(longest_number_string_length)) if any_number_present
      text += format("%s %s  %s\n", op[:amount].rjust(longest_amount_string_length), op[:unit].ljust(longest_unit_string_length), op[:name])
    end
    text
  end
end
