guard :bundler do
  watch('Gemfile')
end

guard :rspec, all_after_pass: false, all_on_start: false do
  watch(%r{^app/(.*)\.rb$}) { |m| "spec/#{m[1]}_spec.rb"}
  watch(%r{^lib/(.*)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/.+_spec\.rb$})
end

guard :jasmine, server_env: :test, port: 8888 do
  watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$}) { 'spec/javascripts' }
  watch(%r{spec/javascripts/.+_spec\.(js\.coffee|js|coffee)$})
  watch(%r{app/assets/javascripts/(.+?)\.(js\.coffee|js|coffee)(?:\.\w+)*$}) { |m| "spec/javascripts/#{ m[1] }_spec.#{ m[2] }" }
  watch(%r{js/(.+?)\.(js\.coffee|js|coffee)(?:\.\w+)*$}) { |m| "spec/javascripts/#{ m[1] }_spec.#{ m[2] }" }
end

guard 'cucumber', all_after_pass: false, all_on_start: false do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end

guard 'rails' do
  watch('Gemfile.lock')
  watch(%r{^(config)/.*})
end

# guard 'sidekiq', environment: 'development' do
#   watch(%r{^app/(.+)\.rb$})
#   watch(%r{^(config|lib)/.*})
# end

guard 'migrate' do
  watch(%r{^db/migrate/(\d+).+\.rb})
  watch('db/seeds.rb')
end
