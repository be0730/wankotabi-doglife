FactoryBot.define do
  factory :tag do
    sequence(:key)  { |n| "key_#{n}" }
    sequence(:name) { |n| "タグ#{n}" }
  end
end
