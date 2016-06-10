#-*- mode: ruby -*-

gemspec

jruby_plugin( :minitest, :minispecDirectory =>"spec/*spec.rb" ) do
  execute_goals(:spec)
end

#snapshot_repository :jruby, 'http://ci.jruby.org/snapshots/maven'

# (jruby-1.6.7 produces a lot of yaml errors parsing gemspecs)
properties( 'jruby.plugins.version' => '1.1.4',
            'jruby.versions' => ['1.7.12', '1.7.25', '9.0.5.0', '9.1.2.0'].join(','),
            'jruby.modes' => ['1.9', '2.0', '2.2'].join(','),
            # just lock the versions
            'jruby.version' => '9.1.2.0' )

profile :id => :release do
  properties 'maven.test.skip' => true, 'invoker.skip' => true, 'push.skip' => false

  build do
    default_goal :deploy
  end

end

# vim: syntax=Ruby
