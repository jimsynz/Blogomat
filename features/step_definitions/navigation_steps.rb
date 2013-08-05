When(/^I visit the site$/) do
  visit '/'
end

When(/^I click the "(.*?)" navigation entry$/) do |section|
  within('.side-nav') do
    click_link section
  end
end
