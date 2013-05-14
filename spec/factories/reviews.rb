require 'faker'

FactoryGirl.define do
  factory :review do
    rate { rand(1..5) }
    body { Faker::Lorem.characters}

    factory :invalid_review do
      body nil
    end
  end
end