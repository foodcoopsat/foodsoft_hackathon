module ArticlesHelper
  # useful for highlighting attributes, when synchronizing articles
  def highlight_new(unequal_attributes, attribute)
    return unless unequal_attributes

    unequal_attributes.has_key?(attribute) ? "background-color: yellow" : ""
  end

  def row_classes(article)
    classes = []
    classes << "unavailable" if !article.latest_article_version.availability
    classes << "just-updated" if article.recently_updated && article.latest_article_version.availability
    classes.join(" ")
  end

  def format_supplier_article_unit(article_version)
    return ArticleUnits.as_options.invert[article_version.supplier_order_unit] unless article_version.supplier_order_unit.nil?

    article_version.unit
  end

  def format_group_order_unit(article_version)
    return ArticleUnits.as_options.invert[article_version.group_order_unit] unless article_version.group_order_unit.nil?

    article_version.unit
  end
end
