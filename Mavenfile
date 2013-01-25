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

# overwrite via cli -Djruby.versions=1.6.7
properties['jruby.versions'] = ['1.5.6','1.6.8','1.7.2'].join(',')
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

# build the gem as well
plugin :gem do |g|
  g.in_phase( :package ).execute_goal( :package ).with( :gemspec => 'maven-tools.gemspec' )
end

# Gemfile.lock is just a convenience but a library should work with
# any allowed version. clean will force a bundle install
plugin(:clean, '2.5' ).with :filesets => 
  [ 
   { :directory => './', :includes => ['Gemfile.lock'] } 
  ]

# just lock the versions
properties['jruby.plugins.version'] = '0.29.2'
properties['jruby.version'] = '1.7.2'

# add the ruby files to jar
build.resources.add do |r|
  r.directory '${project.basedir}/lib'
end

plugin :gem do |g|
  # push is broken with jruby-plugin version 0.29.2
  g.in_phase( :deploy ).execute_goal( :push ).with( :gem => "${project.build.directory}/maven-tools-#{spec_version}.gem" )
  g.gem 'jruby-openssl'
end

execute_in_phase( :initialize ) do
  if File.exists?( '.pom.xml' )
    pom = File.read( 'pom.xml' )
    dot_pom = File.read( '.pom.xml' )
    # on release there are no SNAPSHOTS in that case leave things
    # as they are
    if pom != dot_pom && nil != (pom =~ /-SNAPSHOT/)
      File.open( 'pom.xml', 'w' ) { |f| f.puts dot_pom }
    end
  end
end
