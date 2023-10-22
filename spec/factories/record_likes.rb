FactoryBot.define do
  factory :record_like do
    user { User.first || association(:user) }
    association :record
  end
end
