#-*- mode: ruby -*-

parent 'org.sonatype.oss:oss-parent', '7'

packaging 'jar'
group_id 'de.saumya.mojo'

# let ruby-maven build snapshots only
spec_version = version.to_s
version spec_version + '-SNAPSHOT'

source_control do |sc|
  u = url.sub!( /^https?:\/\//, '' ) if url
  sc.connection "scm:git:git://#{u}.git"
  sc.developer_connection "scm:git:ssh://git@#{u}.git"
  sc.url url
end

plugin(:minitest) do |m|
  m.with :minispecDirectory =>"spec/*spec.rb"
  m.execute_goal(:spec)
end

plugin(:rspec) do |m|
  m.with :specSourceDirectory=>"rspec"
  m.execute_goal(:test)
end

# Gemfile.lock is just a convenience but a library should work with
# any allowed version. clean will force a bundle install
plugin(:clean, '2.5' ).with :filesets => 
  [ 
   { :directory => './', :includes => ['Gemfile.lock'] } 
  ]

plugin :gem do |g|

  # push gem to rubygems on deploy
  g.in_phase( :deploy ).execute_goal( :push ).with( :gem => "${project.build.directory}/maven-tools-#{spec_version}.gem" )

  # copy .pom.xml from ruby-maven
  g.in_phase( :validate ).execute_goal( :pom ).with( :tmpPom => '.pom.xml', :skipGeneration => true )

  # build the gem along with the jar
  g.in_phase( :package ).execute_goal( :package ).with( :gemspec => 'maven-tools.gemspec' )
end

# just lock down the versions
properties['jruby.plugins.version'] = '0.29.3-SNAPSHOT'
properties['jruby.version'] = '1.7.2'

# overwrite via cli -Djruby.versions=1.6.7
properties['jruby.versions'] = ['1.5.6','1.6.8','1.7.2'].join(',')
# overwrite via cli -Djruby.use18and19=false
properties['jruby.18and19'] = true

# add the ruby files to jar
build.resources.add do |r|
  r.directory '${project.basedir}/lib'
end
