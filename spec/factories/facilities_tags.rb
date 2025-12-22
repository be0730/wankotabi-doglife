FactoryBot.define do
  factory :facilities_tag do
    association :facility
    association :tag
  end
end
