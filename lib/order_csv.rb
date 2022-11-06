require 'csv'

class OrderCsv < RenderCSV
  def header
    [
      OrderArticle.human_attribute_name(:units_to_order),
      Article.human_attribute_name(:order_number),
      Article.human_attribute_name(:name),
      Article.human_attribute_name(:unit),
      Article.human_attribute_name(:unit_quantity_short),
      ArticleVersion.human_attribute_name(:price),
      OrderArticle.human_attribute_name(:total_price)
    ]
  end

  def data
    @object.order_articles.ordered.includes([:article, :article_version]).all.map do |oa|
      yield [
        oa.units_to_order,
        oa.article_version.order_number,
        oa.article_version.name,
        oa.article_version.unit,
        oa.article_version.unit_quantity > 1 ? oa.article_version.unit_quantity : nil,
        number_to_currency(oa.article_version.price * oa.article_version.unit_quantity),
        number_to_currency(oa.total_price)
      ]
    end
  end
end
