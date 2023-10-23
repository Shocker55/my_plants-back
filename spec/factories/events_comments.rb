FactoryBot.define do
  factory :event_comment do
    user { User.first || association(:user) }
    association :record
    sequence(:comment) { |n| "Example Comment#{n}" }
  end
end
