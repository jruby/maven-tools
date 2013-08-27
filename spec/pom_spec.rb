require File.expand_path( 'spec_helper', File.dirname( __FILE__ ) )
require 'maven/tools/pom'

describe Maven::Tools::POM do

  Dir[ File.join( File.dirname( __FILE__ ), 'gem*' ) ].each do |dir|
    if File.directory?( dir )
      it "should convert #{dir}" do
        pom = Maven::Tools::POM.new( dir )
        pom_xml = File.read( File.join( dir, 'pom.xml' ) )
        pom_xml.sub!( /<!--(.|\n)*-->\n/, '' )
        pom_xml.sub!( /<?.*?>\n/, '' )
        pom_xml.sub!( /<project([^>]|\n)*>/, '<project>' )
        
        pom.to_s.must_equal pom_xml
      end
    end
  end

end
