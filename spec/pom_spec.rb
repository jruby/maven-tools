require File.expand_path( 'spec_helper', File.dirname( __FILE__ ) )
require 'maven/tools/pom'
require 'maven/tools/versions'

describe Maven::Tools::POM do

  ( Dir[ File.join( File.dirname( __FILE__ ), 'gem*' ) ] + Dir[ File.join( File.dirname( __FILE__ ), 'pom*' ) ] + Dir[ File.join( File.dirname( __FILE__ ), 'mavenfile*' ) ] ).each do |dir|
    if File.directory?( dir )
      it "should convert #{dir}" do
        pom = Maven::Tools::POM.new( dir )
        file = File.join( dir, 'pom.xml' )
        file = File.join( File.dirname( dir ), 'pom.xml' ) unless File.exists? file
        pom_xml = File.read( file )
        pom_xml.sub!( /<!--(.|\n)*-->\n/, '' )
        pom_xml.sub!( /<?.*?>\n/, '' )
        pom_xml.sub!( /<project([^>]|\n)*>/, '<project>' )
        pom_xml.gsub!( /io.tesla.polyglot/, 'io.takari.polyglot' )
        pom_xml.gsub!( /tesla-polyglot/, 'polyglot' )
        pom_xml.gsub!( /${tesla.version}/, Maven::Tools::VERSIONS[ :polyglot_version ] )

        _(pom.to_s).must_equal pom_xml
      end
    end
  end

end
