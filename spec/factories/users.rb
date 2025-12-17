FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}_#{rand(1000)}" }
    sequence(:email) { |n| "user_#{n}_#{rand(1000)}@example.com" } # 乱数を追加
    password { "password" }
    password_confirmation { "password" }
  end
end
