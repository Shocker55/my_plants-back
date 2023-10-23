FactoryBot.define do
  factory :record_comment do
    user { User.first || association(:user) }
    association :record
    sequence(:comment) { |n| "Example Comment#{n}" }
  end
end
