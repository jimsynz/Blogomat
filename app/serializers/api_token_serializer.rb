class ApiTokenSerializer < ApplicationSerializer
  attributes :token, :ttl
  has_one    :user
end
