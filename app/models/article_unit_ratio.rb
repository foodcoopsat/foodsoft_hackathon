class ArticleUnitRatio < ApplicationRecord
  belongs_to :article_version

  validates_presence_of :quantity, :sort, :unit
  validates_numericality_of :quantity, :greater_than => 0
end
