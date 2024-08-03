class OrderByArticles < OrderPdf
  def filename
    I18n.t('documents.order_by_articles.filename', name: order.name, date: order.ends.to_date) + '.pdf'
  end

  def title
    I18n.t('documents.order_by_articles.title', name: order.name,
                                                date: order.ends.strftime(I18n.t('date.formats.default')))
  end

  def body
    each_order_article do |order_article|
      article_version = order_article.article_version
      dimrows = []
      rows = [[
        GroupOrder.human_attribute_name(:ordergroup),
        GroupOrderArticle.human_attribute_name(:ordered),
        GroupOrderArticle.human_attribute_name(:received),
        GroupOrderArticle.human_attribute_name(:total_price)
      ]]

      each_group_order_article_for_order_article(order_article) do |goa|
        dimrows << rows.length if goa.result == 0
        rows << [goa.group_order.ordergroup_name,
                 group_order_quantity_with_tolerance(goa),
                 billing_quantity(goa),
                 number_to_currency(goa.total_price)]
      end
      next unless rows.length > 1

      show_total = order_article.group_order_articles.size > 1
      if show_total
        rows << [I18n.t('documents.total'),
                 total_group_order_quantity_with_tolerance(order_article),
                 total_billing_quantity(order_article),
                 number_to_currency(order_article.group_orders_sum[:price])]
      end

      name = "#{article_version.name} - #{price_per_billing_unit(article_version)}"
      name += " - #{order_article.order.name}" if @options[:show_supplier]
      nice_table name, rows, dimrows do |table|
        table.column(0).width = bounds.width / 2
        table.columns(1..-1).align = :right
        table.column(2).font_style = :bold
        table.row(-1).borders = []
        if show_total
          table.row(-2).border_width = 1
          table.row(-2).border_color = '666666'
        end
      end
    end
  end
end
