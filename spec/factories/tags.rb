FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag Name#{n}" }
  end
end
