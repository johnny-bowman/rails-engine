FactoryBot.define do
  factory :item do
    association :merchant
    name { Faker::Commerce.product_name}
    description { Faker::Commerce.material }
    unit_price { Faker::Number.decimal(r_digits: 2) }  end
end
