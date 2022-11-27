require 'factory_bot'

FactoryBot.define do
  factory :_article do
    factory :article do
      supplier

      transient do
        article_version_count { 1 }
        order_number { nil }
        unit_quantity { nil }
      end

      after(:create) do |article, evaluator|
        create_list(:article_version, evaluator.article_version_count, article: article, order_number: evaluator.order_number, unit_quantity: evaluator.unit_quantity)

        article.reload
      end
    end

    factory :stock_article, class: StockArticle do
      supplier

      transient do
        stock_article_version_count { 1 }
      end

      after(:create) do |stock_article, evaluator|
        create_list(:article_version, evaluator.stock_article_version_count, article: stock_article)

        stock_article.reload
      end
    end
  end
end
