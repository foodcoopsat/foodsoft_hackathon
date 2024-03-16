require 'factory_bot'

FactoryBot.define do
  factory :article_unit_ratio do
    unit { Faker::Unit.unit }
    sort { 1 }
    quantity { 1 } # TODO
    article_version
  end
end
