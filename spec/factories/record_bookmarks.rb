FactoryBot.define do
  factory :record_bookmark do
    user { User.first || association(:user) }
    association :record
  end
end
