module Maven
  module Tools
    unless defined? VERSIONS
      VERSIONS = { 
        :jetty_plugin => "7.5.1.v20110908",
        :jruby_rack => "1.0.10",
        :war_plugin => "2.1.1",
        :jar_plugin => "2.3.1",
        :jruby_plugins => "0.29.0-SNAPSHOT",
        :bundler_version => "1.1.3",
        :jruby_version => defined?(JRUBY_VERSION) ? JRUBY_VERSION : "1.6.7.2"
      }.freeze
    end
  end
end
