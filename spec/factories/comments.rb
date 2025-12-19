FactoryBot.define do
  factory :comment do
    association :user
    association :facility
    body { "サンプルコメント" }
  end
end
