#-*- mode: ruby -*-
#require 'rubygems'
#require 'bundler/setup'
#require 'rspec/core/rake_task'

#RSpec::Core::RakeTask.new(:rspec) do |t|
#  t.pattern = Dir["rspec/maven/**/*_spec.rb"]
#end

task :rspec do
  raise 'failed' unless system "rspec #{Dir['rspec/**/*_spec.rb'].join(' ')}"
end

task :default => [ :minispec, :rspec ]

task :minispec do
  require 'minitest/autorun'

  $LOAD_PATH << "spec"

  Dir['spec/*_spec.rb'].each { |f| require File.basename(f.sub(/.rb$/, '')) }
end
# vim: syntax=Ruby
