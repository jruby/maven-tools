#-*- mode: ruby -*-

gemspec

jruby_plugin( :minitest, :minispecDirectory =>"spec/*spec.rb" ) do
  execute_goals(:spec)
end

#snapshot_repository :jruby, 'http://ci.jruby.org/snapshots/maven'

# (jruby-1.6.7 produces a lot of yaml errors parsing gemspecs)
properties( #'jruby.versions' => ['1.7.12', '1.7.16.1','9.0.0.0-SNAPSHOT'].join(','),
            'jruby.versions' => ['1.7.12', '1.7.16.1'].join(','),
            'jruby.modes' => ['1.9', '2.0','2.1'].join(','),
            # just lock the versions
            'jruby.version' => '1.7.16.1',
            'tesla.dump.pom' => 'pom.xml',
            'tesla.dump.readonly' => true )

# vim: syntax=Ruby
