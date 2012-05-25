#-*- mode: ruby -*-
require 'rubygems'

parent 'org.sonatype.oss:oss-parent', '7'

packaging 'jar'
group_id 'de.saumya.mojo'
artifact_id 'maven-tools'

spec = Gem::Specification.load('maven-tools.gemspec')

version spec.version.to_s + "-SNAPSHOT"

name spec.summary
description spec.description

url spec.homepage

#  <scm>
#    <connection>scm:git:git://github.com/torquebox/jruby-maven-plugins.git</connection>
#    <developerConnection>scm:git:ssh://git@github.com/torquebox/jruby-maven-plugins.git</developerConnection>
#    <url>http://github.com/torquebox/jruby-maven-plugins</url>
#  </scm>

licenses.add('MIT', 'http://www.opensource.org/licenses/mit-license.php')

developers.add(spec.authors[0], spec.email[0])

# overwrite via cli -Djruby.versions=1.6.7
properties['jruby.versions'] = ['1.5.6','1.6.5.1','1.6.7.2','1.7.0.preview1'].join(',')
# overwrite via cli -Djruby.use18and19=false
properties['jruby.18and19'] = true

plugin(:minitest) do |m|
  m.with :minispecDirectory =>"spec/*spec.rb"
  m.execute_goal(:spec)
end

plugin(:rspec) do |m|
  m.with :specSourceDirectory=>"rspec"
  m.execute_goal(:test)
end
