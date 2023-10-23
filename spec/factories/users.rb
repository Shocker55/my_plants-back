FactoryBot.define do
  factory :user do
    uid { "JwMbY12MZCOk3A4eGQfGo3wLUVG2" }
  end
end

FactoryBot.define do
  # factoryの名前をモデル名とは別にしたい場合は、以下のようにクラスを指定する
  factory :archer, class: User do
    uid { "1zyo8MgTOJTLatW0tnow06RUJ2m2" }
  end
end
