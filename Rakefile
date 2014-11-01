#-*- mode: ruby -*-

begin
  require 'maven/ruby/tasks'
rescue LoadError
  # ignore - can not add as development dependency to avoid circular dependencies
end

task :default => [ :specs ]

desc 'generate licenses data from internet'
task :licenses do
  require 'open-uri'
  require 'ostruct'
  
  File.open( 'lib/maven/tools/licenses.rb', 'w' ) do |f|
    url = 'http://opensource.org'
    f.puts "require 'ostruct'"
    f.puts 'module Maven'
    f.puts '  module Tools'
    f.puts '    LICENSES = {}'
    
    open( url + '/licenses/alphabetical' ).each_line do |line|
      
      if line =~ /.*"\/licenses\// and line =~ /<li>/
        l = OpenStruct.new
        line.sub!( /.*"(\/licenses\/([^"]*))">/ ) do
          l.url = "http://opensource.org#{$1}"
          l.short = $1.sub( /\/licenses\//, '' )
          ''
        end
        line.sub!( /\ \(.*$/, '' )
        f.puts "    LICENSES[ #{l.short.downcase.inspect} ] = OpenStruct.new :short => #{l.short.inspect}, :name => #{line.strip.inspect}, :url => #{l.url.inspect}"
      end
    end
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

task :headers do
  require 'copyright_header'

  s = Gem::Specification.load( Dir["*gemspec"].first )

  args = {
    :license => s.license, 
    :copyright_software => s.name,
    :copyright_software_description => s.description,
    :copyright_holders => s.authors,
    :copyright_years => [Time.now.year],
    :add_path => "lib:src",
    :output_dir => './'
  }

  command_line = CopyrightHeader::CommandLine.new( args )
  command_line.execute
end

# vim: syntax=Ruby
