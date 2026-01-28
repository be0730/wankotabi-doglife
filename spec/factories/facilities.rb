FactoryBot.define do
  factory :facility do
    sequence(:title) { |n| "施設名_#{n}" }
    category { 1 }
    city { "新宿区" }
    street { "西新宿1-1" }

    association :user
    association :prefecture
  end
end
