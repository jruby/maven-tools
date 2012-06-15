require 'maven/tools/versions'
unless defined? PLUGINS_VERSION

  # keep plugins version for version test
  PLUGINS_VERSION = Maven::Tools::VERSIONS[:jruby_plugins]

  original_verbosity = $VERBOSE
  $VERBOSE = nil
  
  Maven::Tools::VERSIONS = { 
    :jetty_plugin => "_jetty.version_",
    :jruby_rack => "_jruby.rack.version_",
    :assembly_plugin => "_assembly.version_",
    :war_plugin => "_war.version_",
    :jar_plugin => "_jar.version_",
    :jruby_plugins => "_project.version_",
    :bundler_version => "_bundler.version_",
    :jruby_version => "_jruby.version_"
  }

  $VERBOSE = original_verbosity
end
