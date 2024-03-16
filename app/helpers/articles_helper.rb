module ArticlesHelper
  # useful for highlighting attributes, when synchronizing articles
  def highlight_new(unequal_attributes, attributes)
    attributes = [attributes] unless attributes.is_a?(Array)
    return unless unequal_attributes

    intersection = (unequal_attributes.keys & attributes)
    intersection.empty? ? '' : 'background-color: yellow'
  end

  def row_classes(article)
    classes = []
    classes << 'unavailable' unless article.availability
    classes << 'just-updated' if article.recently_updated && article.availability
    classes.join(' ')
  end

  def format_unit(unit_property, article)
    unit_code = article.send(unit_property)
    return article.unit if unit_code.nil?

    unit = ArticleUnitsLib.units.to_h[unit_code]
    unit[:symbol] || unit[:name]
  end

  def format_supplier_order_unit(article)
    format_unit(:supplier_order_unit, article)
  end

  def format_group_order_unit(article)
    format_unit(:group_order_unit, article)
  end

  def format_billing_unit(article)
    format_unit(:billing_unit, article)
  end

  def format_unit_with_ratios(unit_property, article)
    base = format_unit(unit_property, article)
    unit_code = article.send(unit_property)
    return base if ArticleUnitsLib.unit_is_si_convertible(unit_code)

    relevant_units = [article.article_unit_ratios.map(&:unit)]
    relevant_units << article.supplier_order_unit unless unit_property == :supplier_order_unit
    first_si_convertible_unit = relevant_units
                                .flatten
                                .find { |unit| ArticleUnitsLib.unit_is_si_convertible(unit) }

    return base if first_si_convertible_unit.nil?

    quantity = article.convert_quantity(1, unit_code, first_si_convertible_unit)
    "#{base} (#{format_number(quantity)}\u00a0#{ArticleUnitsLib.units.to_h[first_si_convertible_unit][:symbol]})"
  end

  def format_supplier_order_unit_with_ratios(article)
    format_unit_with_ratios(:supplier_order_unit, article)
  end

  def format_group_order_unit_with_ratios(article)
    format_unit_with_ratios(:group_order_unit, article)
  end

  def format_billing_unit_with_ratios(article)
    format_unit_with_ratios(:billing_unit, article)
  end

  def field_with_preset_value_and_errors(options)
    form, field, value, field_errors, input_html = options.values_at(:form, :field, :value, :errors, :input_html)
    form.input field, label: false, wrapper_html: { class: field_errors.blank? ? '' : 'error' },
                      input_html: input_html do
      output = [form.input_field(field, { value: value }.merge(input_html))]
      if field_errors.present?
        errors = tag.span(class: 'help-inline') do
          field_errors.join(', ')
        end
        output << errors
      end
      safe_join(output)
    end
  end
end
