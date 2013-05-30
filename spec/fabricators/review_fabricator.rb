Fabricator (:review) do
  rate { rand(1..5) }
  body { Faker::Lorem.paragraph}
  video {}
  user {}
end