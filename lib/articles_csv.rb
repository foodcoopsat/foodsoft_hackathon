class ArticlesCsv < RenderCSV
  include ApplicationHelper

  def header
    [
      Article.human_attribute_name(:availability_short),
      Article.human_attribute_name(:order_number),
      Article.human_attribute_name(:name),
      Article.human_attribute_name(:note),
      Article.human_attribute_name(:manufacturer),
      Article.human_attribute_name(:origin),
      Article.human_attribute_name(:unit),
      Article.human_attribute_name(:price),
      Article.human_attribute_name(:tax),
      Article.human_attribute_name(:deposit),
      Article.human_attribute_name(:quantity),
      Article.human_attribute_name(:supplier_order_unit),
      Article.human_attribute_name(:price_unit),
      Article.human_attribute_name(:group_order_unit),
      Article.human_attribute_name(:group_order_granularity),
      Article.human_attribute_name(:minimum_order_quantity),
      '',
      '',
      Article.human_attribute_name(:article_category),
      Article.human_attribute_name(:ratios_to_supplier_order_unit),
    ]
  end

  def data
    @object.each do |article|
      yield [
        '',
        article.order_number,
        article.name,
        article.note,
        article.manufacturer,
        article.origin,
        article.unit,
        article.price,
        article.tax,
        article.deposit,
        article.quantity,
        article.supplier_order_unit,
        article.price_unit,
        article.group_order_unit,
        article.group_order_granularity,
        article.minimum_order_quantity,
        '',
        '',
        article.article_category.try(:name),
        article.article_unit_ratios.map { |ratio| "#{ratio.quantity} #{ratio.unit}" }.join(", ")
      ]
    end
  end
end
