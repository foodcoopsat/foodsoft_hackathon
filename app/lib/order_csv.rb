require 'csv'

class OrderCsv < RenderCsv
  include ApplicationHelper
  include ArticlesHelper

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
    @object.order_articles.ordered.includes(:article_version).all.map do |oa|
      yield [
        oa.units_to_order,
        oa.article_version.order_number,
        oa.article_version.name,
        format_supplier_order_unit_with_ratios(oa.article_version),
        # TODO-article-units: Why should we show the supplier the group order unit quantity?:
        oa.article_version.convert_quantity(1, oa.article_version.supplier_order_unit,
                                            oa.article_version.group_order_unit),
        number_to_currency(oa.article_version.price),
        number_to_currency(oa.total_price)
      ]
    end
  end
end
