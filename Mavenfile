#-*- mode: ruby -*-

gemspec

plugin( 'de.saumya.mojo:minitest-maven-plugin', '${jruby.plugins.version}', 
        :minispecDirectory =>"spec/*spec.rb" ) do
  execute_goals(:spec)
end

# just lock down the versions
properties( 'jruby.plugins.version' => '1.0.0',
            'jruby.version' => '1.7.12',
            # overwrite via cli -Djruby.versions=1.6.7
            'jruby.versions' => ['1.7.4','1.7.12'].join(','),
            # overwrite via cli -Djruby.modes=2.0
            'jruby.modes' => '1.9,2.0,2.1',
            'tesla.dump.pom' => 'pom.xml'
           )

# vim: syntax=Ruby
