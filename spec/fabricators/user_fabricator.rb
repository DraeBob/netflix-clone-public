Fabricator(:user) do
  fullname { Faker::Name.name}
  email { Faker::Internet.email }
  password { Faker::Lorem.characters}
  token { Faker::Lorem.characters }
  admin false 
end

Fabricator(:admin, from: :user) do
  admin true 
end
