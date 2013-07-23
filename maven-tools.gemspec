# -*- mode:ruby -*-
# -*- coding: utf-8 -*-
require File.expand_path('lib/maven/tools/version.rb')
Gem::Specification.new do |s|
  s.name = 'maven-tools'
  s.version = Maven::Tools::VERSION.dup

  s.summary = 'helpers for maven related tasks'
  s.description = 'adds versions conversion from rubygems to maven and vice versa, ruby DSL for POM (Project Object Model from maven), pom generators, etc'
  s.homepage = 'http://github.com/torquebox/maven-tools'

  s.authors = ['Christian Meier']
  s.email = ['m.kristian@web.de']

  s.license = 'MIT'

  s.files += Dir['lib/**/*rb']
  s.files += Dir['spec/**/*rb']
  s.files += Dir['rspec/**/*'].select { |f| f =~ /[a-z]$/ }
  s.files += Dir['MIT-LICENSE'] + Dir['*.md']
  s.test_files += Dir['spec/**/*_spec.rb']
  s.test_files += Dir['rspec/**/*'].select { |f| f =~ /[a-z]$/ }
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'minitest', '~> 4.4'
  s.add_development_dependency 'rspec', '~> 2.7'
  #s.add_development_dependency 'copyright-header', '~> 1.0'
end

# vim: syntax=Ruby
