# -*- mode:ruby -*-
# -*- coding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'maven-tools'
  s.version = '123'

  s.summary = 'helpers for maven related tasks'
  s.description = 'adds versions conversion from rubygems to maven and vice versa, ruby DSL for POM (Project Object Model from maven), pom generators, etc'
  s.homepage = 'http://github.com/torquebox/maven-tools'

  s.authors = ['Christian Meier']
  s.email = ['m.kristian@web.de']

  s.license = 'MIT'

  s.platform = 'java'
  s.requirements << 'jar org.slf4j:slf4j-simple, 1.6.4'
  s.requirements << 'pom org.jruby:jruby, 1.7.16'
  s.requirements << 'jar org.jruby:jruby, 1.7.16, noasm, [org.jruby:jruby-stdlib]'
  s.requirements << 'repo http://localhost/repo'
end

# vim: syntax=Ruby
