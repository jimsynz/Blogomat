Then(/^I should see the about page$/) do
  expect(page.text).to include("About Blogomat")
end
