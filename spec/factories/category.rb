FactoryBot.define do
  factory :category do
    sequence(:label) { |n| "Label-#{n}-category" }
    hidden { false }

    trait :hidden do
      hidden { true }
    end
    factory :hidden_category, traits: %i[hidden]
  end
end
