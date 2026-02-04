#-*- mode: ruby -*-
task :default => [ :specs ]

desc 'generate licenses data from internet'
task :licenses do
  require 'open-uri'
  require 'json'

  File.open( 'lib/maven/tools/licenses.rb', 'w' ) do |f|
    url = 'https://opensource.org'
    f.puts 'module Maven'
    f.puts '  module Tools'
    f.puts '    SpdxLicenseMeta = Struct.new(:short, :name, :url, keyword_init: true)'
    f.puts '    LICENSES = {}'
    
    JSON.parse(URI.open( url + '/api/licenses' ).read)
        .select  { |l| l["spdx_id"].size > 0 && l["name"].size > 0 }
        .sort_by { |l| l["spdx_id"].downcase }
        .each    { |l| f.puts("    LICENSES[ #{l["spdx_id"].downcase.inspect} ] = SpdxLicenseMeta.new( short: #{l["spdx_id"].inspect}, name: #{l["name"].inspect}, url: #{l["_links"]["html"]["href"].inspect} ).freeze") }

    f.puts '    LICENSES.freeze'
    f.puts '  end'
    f.puts 'end'
  end
  
end

desc 'run minispecs'
task :specs do
  begin
    require 'minitest'
  rescue LoadError
  end
  require 'minitest/autorun'

  $LOAD_PATH << "spec"
  $LOAD_PATH << "lib"

  Dir['spec/**/*_spec.rb'].each { |f| require f.sub(/spec\//, '') }
end

# vim: syntax=Ruby
