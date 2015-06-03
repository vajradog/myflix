Fabricator(:invitation) do
  friends_name { Faker::Name.name }
  friends_email { Faker::Internet.email }
  message { Faker::Lorem.paragraph }
end
