FactoryGirl.define do
  factory :post do
    user_id Faker::Number.between(1, 18)
    category_id Faker::Number.between(1, 14)
    title Faker::Lorem.sentence
    content Faker::Lorem.sentence
    link_shop ""
    arena Faker::Number.between(0, 1)
    mode Faker::Number.between(0, 1)
    post_images_attributes {{
      "0" => {
        :_destroy => false,
        :image => []
      }
    }}
  end
end
