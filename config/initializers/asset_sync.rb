AssetSync.configure do |config|
  config.fog_provider = 'Rackspace'
  config.rackspace_username = ENV['RACKSPACE_USERNAME']
  config.rackspace_api_key = ENV['RACKSPACE_API_KEY']
  config.fog_directory = ENV['FOG_DIRECTORY']
  config.fog_region    = ENV['FOG_REGION']
  config.fail_silently = false
end
