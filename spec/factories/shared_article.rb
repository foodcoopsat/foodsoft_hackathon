require 'factory_bot'
FactoryBot.define do
  factory :shared_article do
    sequence(:name) { |n| Faker::Lorem.words(number: rand(2..4)).join(' ') + " s##{n}" }
    number { Faker::Lorem.characters(number: rand(1..12)) }
    shared_supplier
  end
end
