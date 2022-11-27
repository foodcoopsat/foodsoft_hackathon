require 'factory_bot'
FactoryBot.define do
  SharedSupplier.establish_connection(FoodsoftConfig[:shared_lists])
  factory :shared_supplier do
    sequence(:name) { |n| Faker::Lorem.words(number: rand(2..4)).join(' ') + " s##{n}" }
    sequence(:address) { |n| Faker::Lorem.words(number: rand(2..4)).join(' ') + " s##{n}" }
    sequence(:phone) { |n| Faker::Lorem.words(number: rand(2..4)).join(' ') + " s##{n}" }
  end
end
