require 'factory_bot'

task ensure_development_environment: :environment do
  raise "\nI'm sorry, I can't do that.\n(You're asking me to drop your production database.)" if Rails.env.production?
end

# Custom install for development environment
desc "Install"
task install: [:ensure_development_environment, "db:migrate", "db:test:prepare", "db:seed", "populate", "spec"]

# Custom reset for development environment
desc "Reset"
task reset: [:ensure_development_environment, "db:drop", "db:create", "db:migrate", "db:test:prepare", "db:seed"]

# Populates development data
desc "Populate the database with development data."
task populate: :environment do
  Rake::Task['db:reset'].invoke
  FactoryBot.create_list(:user, 1, email: "app-admin@gmail.com", password: "12345678", role: 1)
  FactoryBot.create_list(:user, 2, role: 1)
  FactoryBot.create_list(:user, 10, role: 0)

  7.times do
    cat = Category.create(
      label: Faker::Lorem.characters(number: 10)
    )
    5.times do
      sub = SubCategory.create(
        label: Faker::Lorem.characters(number: 10),
        category_id: cat.id
      )
      5.times do
        Team.create(
          label: Faker::Lorem.characters(number: 10),
          sub_category_id: sub.id
        )
      end
    end
  end
end
