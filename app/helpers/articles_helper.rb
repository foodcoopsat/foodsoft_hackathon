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

  def format_article_unit(article, base_name)
    base_name = base_name.to_s
    return article.send(base_name) if base_name.respond_to?(base_name)

    unit_id = article.send(base_name + '_un_ece')
    ArticleUnits.as_options.invert[unit_id] || ('?' + unit_id.to_s)
  end
end
