class OrderTxt
  include ActionView::Helpers::NumberHelper

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
    text += format("%8s %8s   %s\n", I18n.t('orders.fax.number'), I18n.t('orders.fax.amount'),
                   I18n.t('orders.fax.name'))
    # now display all ordered articles
    @order.order_articles.ordered.includes(:article_version).each do |oa|
      text += format("%8s %8.2f   %s\n", oa.article_version.order_number, oa.units_to_order, oa.article_version.name)
    end
    text
  end
end
