class SharedArticle < ApplicationRecord
  # connect to database from sharedLists-Application
  SharedArticle.establish_connection(FoodsoftConfig[:shared_lists])
  # set correct table_name in external DB
  self.table_name = 'articles'

  belongs_to :shared_supplier, :foreign_key => :supplier_id

  def build_new_article(supplier)
    new_article = supplier.articles.build(
      # convert to db-compatible-string
      shared_updated_on: updated_on.to_formatted_s(:db)
    )

    article_version = new_article.article_versions.build(
      :name => name,
      :unit => unit,
      :supplier_order_unit => nil,
      :note => note,
      :manufacturer => manufacturer,
      :origin => origin,
      :price => price,
      :tax => tax,
      :deposit => deposit,
      :order_number => number,
      :article_category => ArticleCategory.find_match(category)
    )

    new_article.article_versions << article_version
    new_article.latest_article_version = article_version

    article_unit_ratio = article_version.article_unit_ratios.build(
      quantity: unit_quantity,
      unit: 'XPP',
      sort: 1
    )

    article_version.article_unit_ratios << article_unit_ratio

    new_article
  end
end
