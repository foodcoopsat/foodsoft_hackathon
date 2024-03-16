class ArticleUnitRatio < ApplicationRecord
  belongs_to :article_version

  validates :quantity, :sort, :unit, presence: true
  validates :quantity, numericality: { greater_than: 0 }
end
