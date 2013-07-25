# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Baseline::Application.load_tasks

namespace :spec do
  task :javascript do
    `bundle exec guard-jasmine`
  end
end

namespace :ci do
  task prepare: ['db:migrate', 'db:test:prepare']
  task suite: ['spec', 'spec:javascript', 'cucumber', 'clean']
  task clean: ['assets:clean', 'tmp:clear']
end

desc "Run the entire test-suite - used for CI"
task suite: ['ci:prepare', 'ci:suite', 'ci:clean']
