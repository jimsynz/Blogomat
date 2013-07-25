When(/^I visit the homepage$/) do
  visit '/'
end

Then(/^I should see the baseline page$/) do
  expect(page.text).to include('Baseline')
end
