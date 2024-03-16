class ArticlesCsv < RenderCsv
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
      Article.human_attribute_name(:supplier_order_unit),
      Article.human_attribute_name(:price_unit),
      Article.human_attribute_name(:group_order_unit),
      Article.human_attribute_name(:group_order_granularity),
      Article.human_attribute_name(:minimum_order_quantity),
      Article.human_attribute_name(:billing_unit),
      Article.human_attribute_name(:article_category),
      Article.human_attribute_name(:ratios_to_supplier_order_unit)
    ]
  end

  def data
    @object.each do |article|
      yield [
        article.availability ? I18n.t('simple_form.yes') : I18n.t('simple_form.no'),
        article.order_number,
        article.name,
        article.note,
        article.manufacturer,
        article.origin,
        article.unit,
        article.price,
        article.tax,
        article.deposit,
        ArticleUnitsLib.get_translated_name_for_code(article.supplier_order_unit),
        ArticleUnitsLib.get_translated_name_for_code(article.price_unit),
        ArticleUnitsLib.get_translated_name_for_code(article.group_order_unit),
        article.group_order_granularity,
        article.minimum_order_quantity,
        ArticleUnitsLib.get_translated_name_for_code(article.billing_unit),
        article.article_category.try(:name),
        article.article_unit_ratios.map do |ratio|
          "#{ratio.quantity} #{escape_csv_ratio(ArticleUnitsLib.get_translated_name_for_code(ratio.unit))}"
        end.join(', ')
      ]
    end
  end

  def escape_csv_ratio(str)
    str.gsub('\\', '\\\\').gsub(',', '\\,')
  end
end
