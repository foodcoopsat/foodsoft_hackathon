require 'csv'

class OrderCsv < RenderCsv
  include ApplicationHelper
  include ArticlesHelper

  def header
    [
      Article.human_attribute_name(:order_number),
      OrderArticle.human_attribute_name(:units_to_order),
      Article.human_attribute_name(:unit),
      Article.human_attribute_name(:name),
      ArticleVersion.human_attribute_name(:price),
      OrderArticle.human_attribute_name(:total_price)
    ]
  end

  def data
    @object.order_articles.ordered.includes(:article_version).all.map do |oa|
      yield [
        oa.article_version.order_number,
        number_with_precision(oa.units_to_order, precision: 3),
        format_supplier_order_unit_with_ratios(oa.article_version),
        oa.article_version.name,
        number_to_currency(oa.article_version.price),
        number_to_currency(oa.total_price)
      ]
    end
  end
end
