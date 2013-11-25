#-*- mode: ruby -*-
require 'rubygems/package_task'
require 'rspec/core/rake_task'

begin
  require 'maven/ruby/tasks'
rescue LoadError
  # ignore - can not add as development dependency to avoid circular dependencies
end

desc 'run rspec (specs for old API)'
RSpec::Core::RakeTask.new(:rspec) do |t|
  t.pattern = Dir["rspec/maven/**/*_spec.rb"]
end

task :default => [ :minispec, :rspec ]

Gem::PackageTask.new( Gem::Specification.load( 'maven-tools.gemspec' ) ) do
end

desc 'run minispecs'
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

desc 'maven install'
task :install do
  maven.exec( '-P install' )
end

desc 'release current version'
task :release do
  # tell Mavenfile not to use SNAPSHOT version
  ENV['RELEASE'] = 'true'
  maven.exec( :deploy, '-Ppush,sonatype-oss-release' )
  versionFile = File.join( 'lib', 'maven', 'tools', 'version.rb' )
  require File.expand_path( versionFile )
  puts "\n\n\n"
  puts "git ci -m 'release #{Maven::Tools::VERSION}' ."
  puts "git tag #{Maven::Tools::VERSION}"
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
