FactoryBot.define do
  factory :record_tag do
    association :record
    association :tag
  end
end
