class ArticleUnitRatio < ApplicationRecord
  belongs_to :article, optional: true
  belongs_to :article_price, optional: true

  validates_presence_of :quantity, :sort, :unit
  validates_numericality_of :quantity, :greater_than => 0
end
