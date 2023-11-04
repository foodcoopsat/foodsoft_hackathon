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
    return ArticleUnit.as_hash[article.group_order_unit][:name] unless article.group_order_unit.nil?

    article.unit
  end
end
