# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :fmt do
  system 'rubocop -A'
end

task push: :fmt do
  system 'git add .'
  system 'git commit -m "update"'
  system 'git push'
end
