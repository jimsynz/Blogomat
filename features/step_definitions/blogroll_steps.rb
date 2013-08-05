Given(/^there are some published posts$/) do
  10.times.map do |i|
    Fabricate(:post, published_at: i.days.ago)
  end
end

Then(/^I should see the posts$/) do
  Post.published.each do |post|
    expect(page.text).to include(post.subject)
  end
end

Then(/^they should be in reverse chronological order$/) do
  expect(all('.subject').map(&:text)).to eq(Post.published.in_reverse_chronological_order.pluck(:subject))
end
