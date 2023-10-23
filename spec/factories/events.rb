FactoryBot.define do
  factory :event do
    sequence(:title) { |n| "Example Title#{n}" }
    sequence(:body) { |n| "Example Body#{n}" }
    start_date { Date.today + 7 }
    end_date { Date.today + 14 }
    sequence(:place) { |n| "Example Place#{n}" }
    sequence(:latitude) { |n| n }
    sequence(:longitude) { |n| n }
    date_type { 1 }
    user { User.first || association(:user) }
  end
end
