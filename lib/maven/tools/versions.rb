module Maven
  module Tools
    unless defined? VERSIONS
      VERSIONS = { 
        :jruby_rack => "1.1.13.1",
        :assembly_plugin => "2.3",
        :war_plugin => "2.2",
        :jar_plugin => "2.4",
        :jruby_plugins => "0.29.2",
        :bundler_version => "1.2.3",
        :jruby_version => defined?(JRUBY_VERSION) ? JRUBY_VERSION : "1.7.2"
      }.freeze
    end
  end
end
