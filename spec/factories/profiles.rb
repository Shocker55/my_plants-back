FactoryBot.define do
  factory :profile do
    name { "Name" }
    bio { "Example Bio" }
    association :user
  end
end

FactoryBot.define do
  factory :archer_profile, class: Profile do
    name { "Archer" }
    bio { "Archer's Bio" }
    association :user
  end
end
