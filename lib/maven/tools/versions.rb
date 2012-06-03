module Maven
  module Tools
    unless defined? VERSIONS
      VERSIONS = { 
        :jetty_plugin => "7.6.4.v20120524",
        :jruby_rack => "1.1.6",
        :war_plugin => "2.2",
        :jar_plugin => "2.4",
        :jruby_plugins => "0.29.0-SNAPSHOT",
        :bundler_version => "1.1.4",
        :jruby_version => defined?(JRUBY_VERSION) ? JRUBY_VERSION : "1.6.7.2"
      }.freeze
    end
  end
end
