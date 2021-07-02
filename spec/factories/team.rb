FactoryBot.define do
  factory :team do
    label { "LA Lakers" }
    sub_category

    trait :hidden do
      hidden { true }
    end

    factory :hidden_team, traits: %i[hidden]
  end
end
