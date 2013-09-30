#-*- mode: ruby -*-
require 'rubygems/package_task'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:rspec) do |t|
  t.pattern = Dir["rspec/maven/**/*_spec.rb"]
end

task :maven do
  if !defined?( JRUBY_VERSION ) && RUBY_VERSION == "2.0.0"
    raise 'failed' unless system "mvn -P test"
  else
    puts 'skip maven'
  end
end

task :default => [ :maven, :minispec, :rspec ]

Gem::PackageTask.new( Gem::Specification.load( 'maven-tools.gemspec' ) ) do
end

task :minispec do
  begin
    require 'minitest'
  rescue LoadError
  end
  require 'minitest/autorun'

  $LOAD_PATH << "spec"
  $LOAD_PATH << "lib"

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
