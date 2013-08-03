Fabricator(:post) do
  subject      { Faker::Lorem.sentence }
  body         { Faker::Lorem.paragraphs.join("\n\n") }
  user         { Fabricate(:user) }
end

Fabricator(:published_post, from: :post) do
  published_at { 3.days.ago }
end

Fabricator(:pending_post, from: :post) do
  published_at { 3.days.from_now }
end
