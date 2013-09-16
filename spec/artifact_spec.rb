require File.expand_path( 'spec_helper', File.dirname( __FILE__ ) )
require 'maven/tools/artifact'

describe Maven::Tools::Artifact do

  it 'should setup artifact' do
    Maven::Tools::Artifact.new( "sdas", "das", "jar", "123", "tes" ).to_s.must_equal 'sdas:das:jar:tes:123'
    Maven::Tools::Artifact.new( "sdas", "das", "jar", "123" ).to_s.must_equal 'sdas:das:jar:123'
    Maven::Tools::Artifact.new( "sdas.asd", "das", "jar", "123", ["fds:fre"] ).to_s.must_equal 'sdas.asd:das:jar:123:[fds:fre]'
    Maven::Tools::Artifact.new( "sdas.asd", "das", "jar","123",  "bla", ["fds:fre", "ferf:de"] ).to_s.must_equal 'sdas.asd:das:jar:bla:123:[fds:fre,ferf:de]'
    Maven::Tools::Artifact.new( "sdas.asd", "das", "jar", "123", "blub", ["fds:fre", "ferf:de"] ).to_s.must_equal 'sdas.asd:das:jar:blub:123:[fds:fre,ferf:de]'
  end

  it 'should convert ruby version contraints - gems' do
    Maven::Tools::Artifact.from( :gem, 'rubygems:asd', '=1' ).to_s.must_equal 'rubygems:asd:gem:[1,1.0.0.0.0.1)'
    Maven::Tools::Artifact.from( :gem, 'rubygems:asd', '>=1' ).to_s.must_equal 'rubygems:asd:gem:[1,)'
    Maven::Tools::Artifact.from( :gem, 'rubygems:asd', '<=1' ).to_s.must_equal 'rubygems:asd:gem:[0,1]'
    Maven::Tools::Artifact.from( :gem, 'rubygems:asd', '>1' ).to_s.must_equal 'rubygems:asd:gem:(1,)'
    Maven::Tools::Artifact.from( :gem, 'rubygems:asd', '<1' ).to_s.must_equal 'rubygems:asd:gem:[0,1)'
    Maven::Tools::Artifact.from( :gem, 'rubygems:asd', '!1' ).to_s.must_equal 'rubygems:asd:gem:(1,)'
    Maven::Tools::Artifact.from( :gem, 'rubygems:asd', '<2', '>1' ).to_s.must_equal 'rubygems:asd:gem:(1,2)'
    Maven::Tools::Artifact.from( :gem, 'rubygems:asd', '<=2', '>1' ).to_s.must_equal 'rubygems:asd:gem:(1,2]'
    Maven::Tools::Artifact.from( :gem, 'rubygems:asd', '<2', '>=1' ).to_s.must_equal 'rubygems:asd:gem:[1,2)'
    Maven::Tools::Artifact.from( :gem, 'rubygems:asd', '<=2', '>=1' ).to_s.must_equal 'rubygems:asd:gem:[1,2]'
  end

  it 'should convert ruby version contraints - jars' do
    Maven::Tools::Artifact.from( :jar, 'rubygems:asd', '=1' ).to_s.must_equal 'rubygems:asd:jar:[1,1.0.0.0.0.1)'
    Maven::Tools::Artifact.from( :jar, 'rubygems:asd', '>=1' ).to_s.must_equal 'rubygems:asd:jar:[1,)'
    Maven::Tools::Artifact.from( :jar, 'rubygems:asd', '<=1' ).to_s.must_equal 'rubygems:asd:jar:[0,1]'
    Maven::Tools::Artifact.from( :jar, 'rubygems:asd', '>1' ).to_s.must_equal 'rubygems:asd:jar:(1,)'
    Maven::Tools::Artifact.from( :jar, 'rubygems:asd', '<1' ).to_s.must_equal 'rubygems:asd:jar:[0,1)'
    Maven::Tools::Artifact.from( :jar, 'rubygems:asd', '!1' ).to_s.must_equal 'rubygems:asd:jar:(1,)'
    Maven::Tools::Artifact.from( :jar, 'rubygems:asd', '<2', '>1' ).to_s.must_equal 'rubygems:asd:jar:(1,2)'
    Maven::Tools::Artifact.from( :jar, 'rubygems:asd', '<=2', '>1' ).to_s.must_equal 'rubygems:asd:jar:(1,2]'
    Maven::Tools::Artifact.from( :jar, 'rubygems:asd', '<2', '>=1' ).to_s.must_equal 'rubygems:asd:jar:[1,2)'
    Maven::Tools::Artifact.from( :jar, 'rubygems:asd', '<=2', '>=1' ).to_s.must_equal 'rubygems:asd:jar:[1,2]'
  end
end
