require 'faker'

FactoryGirl.define do
  factory :user do
    fullname { Faker::Name.name}
    email { Faker::Internet.email }
    password { Faker::Lorem.characters}

    factory :invalid_user do
      password nil
    end
  end
end