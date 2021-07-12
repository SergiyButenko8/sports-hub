FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    password { Faker::Internet.password }
    email { Faker::Internet.safe_email }
    # sequence :email do |n|
    # "user#{n}@gmail.com"
    # end

    trait :empty_name do
      first_name { nil }
      last_name { nil }
    end

    trait :admin do
      role { 1 }
    end

    trait :user do
      role { 0 }
    end

    trait :active do
      status { 0 }
    end

    trait :blocked do
      status { 1 }
    end

    factory :admin_user, traits: %i[admin active]
    factory :regular_user, traits: %i[user active]
    factory :blocked_user, traits: %i[user blocked]
  end
end
