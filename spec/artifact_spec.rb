require 'maven/tools/artifact'

describe Maven::Tools::Artifact do

  it 'should setup artifact' do
    Maven::Tools::Artifact.new( "sdas", "das", "jar", "tes", "123" ).to_s.must_equal 'sdas:das:jar:tes:123'
    Maven::Tools::Artifact.new( "sdas", "das", "jar", "123" ).to_s.must_equal 'sdas:das:jar:123'
    Maven::Tools::Artifact.new( "sdas.asd", "das", "jar", "123", ["fds:fre"] ).to_s.must_equal 'sdas.asd:das:jar:123:[fds:fre]'
    Maven::Tools::Artifact.new( "sdas.asd", "das", "jar", "bla", "123", ["fds:fre", "ferf:de"] ).to_s.must_equal 'sdas.asd:das:jar:bla:123:[fds:fre,ferf:de]'
    Maven::Tools::Artifact.new( "sdas.asd", "das", "jar", "blub", "123", ["fds:fre", "ferf:de"] ).to_s.must_equal 'sdas.asd:das:jar:blub:123:[fds:fre,ferf:de]'
  end
end
