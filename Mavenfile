#-*- mode: ruby -*-

gemspec

# we need only the metadata - no extenions, deps, repos, plugins !!
model.build.extensions.clear
model.build.plugins.clear
model.dependencies.clear
model.repositories.clear

parent 'org.sonatype.oss:oss-parent', '7'

packaging 'jar'
group_id 'de.saumya.mojo'

# let ruby-maven build snapshots only
spec_version = model.version.to_s
version spec_version + '-SNAPSHOT'

u = model.url.sub!( /^https?:\/\//, '' ) if model.url
source_control( model.url,
                :connection => "scm:git:git://#{u}.git",
                :developer_connection => "scm:git:ssh://git@#{u}.git" )

profile( :test ) do

  gemspec

  plugin( 'de.saumya.mojo:minitest-maven-plugin', '${jruby.plugins.version}', 
          :minispecDirectory =>"spec/*spec.rb" ) do
    execute_goals(:spec)
  end

  plugin( 'de.saumya.mojo:rspec-maven-plugin', '${jruby.plugins.version}',
          :specSourceDirectory=>"rspec" ) do
    execute_goals(:test)
  end

  # Gemfile.lock is just a convenience but a library should work with
  # any allowed version. clean will force a bundle install
  plugin(:clean, '2.5', 
         :filesets => [ { :directory => './',
                          :includes => ['Gemfile.lock'] } ] )
  
end

profile :push do

  build do
    default_goal 'gem:push'

    plugin 'de.saumya.mojo:gem-maven-plugin', '${jruby.plugins.version}' do
    
      # push gem to rubygems on deploy
      execute_goals( :push, :id => 'gem push',
                     :gem => "${project.build.directory}/maven-tools-#{spec_version}.gem" )
    
    end
  end
end

plugin 'de.saumya.mojo:gem-maven-plugin', '${jruby.plugins.version}' do

  # build the gem along with the jar
  execute_goals( :package, :id => 'gem build',
                 :phase => :package,
                 :gemspec => 'maven-tools.gemspec' )
end

# just lock down the versions
properties( #'jruby.plugins.version' => '1.0.0-rc2',
            'jruby.version' => '1.7.4',
            # overwrite via cli -Djruby.versions=1.6.7
            'jruby.versions' => ['1.5.6','1.6.8','1.7.4'].join(','),
            # overwrite via cli -Djruby.use18and19=false
            'jruby.18and19' => true )

properties 'tesla.dump.pom' => 'pom.xml'

# add the ruby files to jar
resource do
  directory '${project.basedir}/lib'
end
