#-*- mode: ruby -*-
require 'rubygems/package_task'
require 'rspec/core/rake_task'

desc 'run rspec (specs for old API)'
RSpec::Core::RakeTask.new(:rspec) do |t|
  t.pattern = Dir["rspec/maven/**/*_spec.rb"]
end

task :maven do
  if !defined?( JRUBY_VERSION ) && RUBY_VERSION == "2.0.0"
    # TODO use ruby-maven tasks
    raise 'failed' unless system "mvn -P test"
  else
    puts 'skip maven'
  end
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

desc 'release current version'
task :release do
  ENV['RELEASE'] = 'true'
  maven.exec( :deploy, '-Ppush,sonatype-oss-release' )
  versionFile = File.join( 'lib', 'maven', 'tools', 'version.rb' )
  require File.expand_path( versionFile )
  `git tag #{Maven::Tools::VERSION}`
  file = File.read( versionFile )
  file.sub!( /#{Maven::Tools::VERSION}/, 
             Gem::Version.new( Maven::Tools::VERSION ).bump.to_s )
  File.open( versionFile, 'w' ) { |f| f.print( file ) }
  `git commit -m 'version bump' #{versionFile}`
  `git push --tags`
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
