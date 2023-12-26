module ArticlesHelper
  # useful for highlighting attributes, when synchronizing articles
  def highlight_new(unequal_attributes, attributes)
    attributes = [attributes] unless attributes.is_a?(Array)
    return unless unequal_attributes

    intersection = (unequal_attributes.keys & attributes)
    intersection.empty? ? "" : "background-color: yellow"
  end

  def row_classes(article)
    classes = []
    classes << "unavailable" if !article.availability
    classes << "just-updated" if article.recently_updated && article.availability
    classes.join(" ")
  end

  def format_supplier_article_unit(article)
    return ArticleUnit.as_hash[article.supplier_order_unit][:name] unless article.supplier_order_unit.nil?

    article.unit
  end

  def format_group_order_unit(article)
    return article.unit if article.group_order_unit.nil?

    unit = ArticleUnitsLib.units.to_h[article.group_order_unit]
    unit[:symbol] || unit[:name]
  end

  def format_supplier_order_unit_with_ratios(article)
    base = format_supplier_article_unit(article)
    return base if ArticleUnitsLib.unit_is_si_convertible(article.supplier_order_unit)

    first_si_convertible_unit = article.article_unit_ratios.map(&:unit)
                                       .find { |unit| ArticleUnitsLib.unit_is_si_convertible(unit) }
    return base if first_si_convertible_unit.nil?

    quantity = article.convert_quantity(1, article.supplier_order_unit, first_si_convertible_unit)
    "#{base} (#{format_number(quantity)}#{ArticleUnitsLib.units.to_h[first_si_convertible_unit][:symbol]})"
  end

  def format_group_order_unit_with_ratios(article)
    base = format_group_order_unit(article)
    return base if ArticleUnitsLib.unit_is_si_convertible(article.group_order_unit)

    first_si_convertible_unit = [article.article_unit_ratios.map(&:unit), article.supplier_order_unit]
                                .flatten
                                .find { |unit| ArticleUnitsLib.unit_is_si_convertible(unit) }

    return base if first_si_convertible_unit.nil?

    quantity = article.convert_quantity(1, article.group_order_unit, first_si_convertible_unit)
    "#{base} (#{format_number(quantity)}#{ArticleUnitsLib.units.to_h[first_si_convertible_unit][:symbol]})"
  end
end
