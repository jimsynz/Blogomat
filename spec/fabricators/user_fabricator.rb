Fabricator(:user) do
  email    { Faker::Internet.email }
  name     { Faker::Name.name }
  username { Faker::Internet.user_name }
  password { Faker::Lorem.word }
end
