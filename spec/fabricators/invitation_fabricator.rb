Fabricator (:invitation) do
  friend_name { Faker::Name.name }
  friend_email { Faker::Internet.email }
  message { Faker::Lorem.characters }
  token { Faker::Lorem.characters }
  inviter_id { rand(1..99) }
end