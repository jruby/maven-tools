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

task :headers do
  require 'copyright_header'

  s = Gem::Specification.load( Dir["*gemspec"].first )

  args = {
    :license => s.license, 
    :copyright_software => s.name,
    :copyright_software_description => s.description,
    :copyright_holders => s.authors,
    :copyright_years => [Time.now.year],
    :add_path => "lib:src",
    :output_dir => './'
  }

  command_line = CopyrightHeader::CommandLine.new( args )
  command_line.execute
end

# vim: syntax=Ruby
