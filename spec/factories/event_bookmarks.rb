FactoryBot.define do
  factory :event_bookmark do
    user { User.first || association(:user) }
    association :event
  end
end
