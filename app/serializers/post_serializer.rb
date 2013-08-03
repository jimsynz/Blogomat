class PostSerializer < ApplicationSerializer
  attributes :id, :subject, :body, :published_at
  has_one    :user
end
