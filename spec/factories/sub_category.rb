FactoryBot.define do
  factory :sub_category do
    label { "Western Conference" }
    category

    trait :visible do
      hidden { false }
    end

    factory :visible_sub_category, traits: %i[visible]
  end
end
