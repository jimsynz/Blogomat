class PostSerializer < ApplicationSerializer
  attributes :subject, :body, :published_at
  has_one    :user
end
