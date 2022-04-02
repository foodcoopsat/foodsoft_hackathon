module ArticlesHelper
  # useful for highlighting attributes, when synchronizing articles
  def highlight_new(unequal_attributes, attribute)
    return unless unequal_attributes

    unequal_attributes.has_key?(attribute) ? "background-color: yellow" : ""
  end

  def row_classes(article)
    classes = []
    classes << "unavailable" if !article.availability
    classes << "just-updated" if article.recently_updated && article.availability
    classes.join(" ")
  end

  def format_supplier_article_unit(article)
    return ArticleUnits.as_options.invert[article.supplier_order_unit] unless article.supplier_order_unit.nil?

    article.unit
  end

  def format_group_order_unit(article)
    return ArticleUnits.as_options.invert[article.group_order_unit] unless article.group_order_unit.nil?

    article.unit
  end
end
