require 'faker'

FactoryGirl.define do
  factory :user do
    fullname { Faker::Name.name}
    email { Faker::Internet.email }
    password { Faker::Lorem.characters}
  end
end