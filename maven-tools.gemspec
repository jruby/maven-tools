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
  s.files += Dir['MIT-LICENSE'] + Dir['*.md']
  s.test_files += Dir['spec/**/*_spec.rb']

  s.add_runtime_dependency 'virtus', '~> 1.0'

# get them out from here until jruby-maven-plugin installs test gems somewhere else then runtime gems

  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'minitest', '~> 5.3'
end

# vim: syntax=Ruby
