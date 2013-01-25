# -*- coding: utf-8 -*-
require File.expand_path('lib/maven/tools/version.rb')
Gem::Specification.new do |s|
  s.name = 'maven-tools'
  s.version = '0.32.0'

  s.summary = 'helpers for maven related tasks'
  s.description = 'adds versions conversion from rubygems to maven and vice versa, ruby DSL for POM (Project Object Model from maven), pom generators, etc'
  s.homepage = 'http://github.com/torquebox/maven-tools'

  s.authors = ['Christian Meier']
  s.email = ['m.kristian@web.de']

  s.add_development_dependency 'rake', '~> 10.0.3'
  s.add_development_dependency 'minitest', '~> 4.4'
  s.add_development_dependency 'rspec', '2.7'
end
