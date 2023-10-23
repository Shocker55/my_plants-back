FactoryBot.define do
  factory :record do
    sequence(:title) { |n| "Example Title#{n}" }
    sequence(:body) { |n| "Example Body#{n}" }
    user { User.first || association(:user) }
  end
end
