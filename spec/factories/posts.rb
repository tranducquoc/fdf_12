FactoryGirl.define do
  factory :post do
    association :user
    association :category
    title Faker::Lorem.sentence
    content Faker::Lorem.sentence
    link_shop ""
    arena Post.arenas.keys.sample
    mode Post.modes.keys.sample
    min_price Faker::Number.between(1, 1000000)
    max_price Faker::Number.between(1000000, 10000000)
    status Faker::Number.between(0, 3)
    domain_id Faker::Number.between(1,5)
  end
end
