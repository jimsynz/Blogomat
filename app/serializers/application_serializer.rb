# Superclass for our serializers, just in case there's behaviour we need to share.
class ApplicationSerializer < ActiveModel::Serializer
  # Mix in route helpers, so that we can include links
  # to other API endpoints, should we need to.
  include Rails.application.routes.url_helpers

  embed :ids

end
