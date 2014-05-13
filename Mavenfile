#-*- mode: ruby -*-

gemspec

plugin( 'de.saumya.mojo:minitest-maven-plugin', '${jruby.plugins.version}', 
        :minispecDirectory =>"spec/*spec.rb" ) do
  execute_goals(:spec)
end

properties( # lock down versions
            'jruby.plugins.version' => '1.0.1',
            'jruby.version' => '1.7.12',

            # running the specs with this matrix
            # (jruby-1.6.7 produces a lot of yaml errors parsing gemspecs)
            # overwrite via cli -Djruby.versions=9000.dev-SNAPSHOT
            'jruby.versions' => ['1.7.4','1.7.12'].join(','),
            # overwrite via cli -Djruby.modes=2.0
            'jruby.modes' => '1.9,2.0,2.1'
           )

# vim: syntax=Ruby
