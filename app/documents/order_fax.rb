class OrderFax < OrderPdf
  include ArticlesHelper

  BATCH_SIZE = 250

  def filename
    I18n.t('documents.order_fax.filename', name: order.name, date: order.ends.to_date) + '.pdf'
  end

  def title
    false
  end

  def body
    from_paragraph

    recipient_paragraph

    articles_paragraph
  rescue StandardError => e
    Rails.logger.info e.backtrace
    raise # always reraise
  end

  private

  def from_paragraph
    contact = FoodsoftConfig[:contact].symbolize_keys
    bounding_box [margin_box.right - 200, margin_box.top], width: 200 do
      text FoodsoftConfig[:name], size: fontsize(9), align: :right
      move_down 5
      text contact[:street], size: fontsize(9), align: :right
      move_down 5
      text "#{contact[:zip_code]} #{contact[:city]}", size: fontsize(9), align: :right
      move_down 5
      if order.supplier.try(:customer_number).present?
        text "#{Supplier.human_attribute_name :customer_number}: #{order.supplier[:customer_number]}",
             size: fontsize(9), align: :right
        move_down 5
      end
      if contact[:phone].present?
        text "#{Supplier.human_attribute_name :phone}: #{contact[:phone]}", size: fontsize(9), align: :right
        move_down 5
      end
      if contact[:email].present?
        text "#{Supplier.human_attribute_name :email}: #{contact[:email]}", size: fontsize(9),
                                                                            align: :right
      end
    end
  end

  def recipient_paragraph
    bounding_box [margin_box.left, margin_box.top - 60], width: 200 do
      text order.name
      move_down 5
      text order.supplier.try(:address).to_s
      if order.supplier.try(:fax).present?
        move_down 5
        text "#{Supplier.human_attribute_name :fax}: #{order.supplier[:fax]}"
      end
    end

    move_down 5
    text Date.today.strftime(I18n.t('date.formats.default')), align: :right

    move_down 10
    text "#{Delivery.human_attribute_name :date}:"
    move_down 10
    return if order.supplier.try(:contact_person).blank?

    text "#{Supplier.human_attribute_name :contact_person}: #{order.supplier[:contact_person]}"
    move_down 10
  end

  def articles_paragraph
    total = 0
    data = [I18n.t('documents.order_fax.rows')]
    each_order_article do |oa|
      price = oa.article_version.price
      subtotal = oa.units_to_order * price
      total += subtotal
      data << [oa.article_version.order_number,
               number_with_precision(oa.units_to_order, precision: 3),
               format_supplier_order_unit_with_ratios(oa.price),
               oa.article_version.name,
               number_to_currency(price),
               number_to_currency(subtotal)]
    end
    data << [I18n.t('documents.order_fax.total'), nil, nil, nil, nil, number_to_currency(total)]
    table data, cell_style: { size: fontsize(8), overflow: :shrink_to_fit } do |table|
      table.header = true
      table.cells.border_width = 1
      table.cells.border_color = '666666'

      table.row(0).border_bottom_width = 2
      table.columns(1).align = :right
      table.columns(4..5).align = :right
      table.row(data.length - 1).columns(0..4).borders = %i[top bottom]
      table.row(data.length - 1).columns(0).borders = %i[top bottom left]
      table.row(data.length - 1).border_top_width = 2
    end
    # font_size: fontsize(8),
    # vertical_padding: 3,
    # border_style: :grid,
    # headers: ["BestellNr.", "Menge","Name", "Gebinde", "Einheit","Preis/Einheit"],
    # align: {0 => :left}
  end

  def order_articles
    order.order_articles.ordered
         .joins(:article_version)
         .order('article_versions.order_number').order('article_versions.name')
         .preload(article_version: :article)
  end

  def each_order_article(&block)
    order_articles.find_each_with_order(batch_size: BATCH_SIZE, &block)
  end
end
