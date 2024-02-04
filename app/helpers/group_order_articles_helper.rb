module GroupOrderArticlesHelper
  # return an edit field for a GroupOrderArticle result
  def group_order_article_edit_result(goa, convert_to_billing_unit = true)
    result = number_with_precision goa.result, strip_insignificant_zeros: true
    unless goa.group_order.order.finished? && current_user.role_finance?
      result
    else
      order_article = goa.order_article
      article_version = order_article.article_version
      simple_form_for goa, remote: true, html: { 'data-submit-onchange' => 'changed', class: 'delta-input' } do |f|
        quantity_data = ratio_quantity_data(order_article, order_article.article_version.billing_unit)
        converted_value = convert_to_billing_unit ? article_version.convert_quantity(goa.result, article_version.group_order_unit, article_version.billing_unit) : result
        input_data = { min: 0 }.merge(quantity_data)
        input_data = input_data.merge('multiply-before-submit': article_version.convert_quantity(1, article_version.billing_unit, article_version.group_order_unit)) if convert_to_billing_unit
        f.input_field(:result, as: :delta, class: 'input-nano', data: input_data, id: "r_#{goa.id}", value: converted_value)
      end
    end
  end
end
