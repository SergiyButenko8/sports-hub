FactoryBot.define do
  factory :user do
    first_name { "Sergiy" }
    last_name { "Butenko" }
    password { "123456" }
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
    factory :blocked_user, traits: %i[user blocked]
  end
end
