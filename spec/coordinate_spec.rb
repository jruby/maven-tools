require 'maven/tools/coordinate'
class A
  include Maven::Tools::Coordinate
end

describe Maven::Tools::Coordinate do

  subject { A.new }

  it 'should convert ruby version to maven version ranges' do
    subject.to_version.must_equal "[0,)"
    subject.to_version('!2.3.4').must_equal "(2.3.4,)"
    subject.to_version('=2.3.4').must_equal "[2.3.4,2.3.4.0.0.0.0.1)"
    subject.to_version('~>1.8.2').must_equal "[1.8.2,1.8.99999]"
    subject.to_version('~>1.8.2.beta').must_equal "[1.8.2.beta,1.8.99999]"
    subject.to_version('~>1.8.2.beta123.12').must_equal "[1.8.2.beta123.12,1.8.99999]"
    subject.to_version('~>1.8.2.1beta').must_equal "[1.8.2.1beta,1.8.99999]"
    subject.to_version('~>1.8').must_equal "[1.8,1.99999]"
    subject.to_version('>1.2').must_equal "(1.2,)"
    subject.to_version('<1.2').must_equal "[0,1.2)"
    subject.to_version('>=1.2').must_equal "[1.2,)"
    subject.to_version('<=1.2').must_equal "[0,1.2]"
    subject.to_version('>=1.2', '<2.0').must_equal "[1.2,2.0)"
    subject.to_version('>=1.2', '<=2.0').must_equal "[1.2,2.0]"
    subject.to_version('>1.2', '<2.0').must_equal "(1.2,2.0)"
    subject.to_version('>1.2', '<=2.0').must_equal "(1.2,2.0]"
  end
  
  it 'should keep maven version and ranges as they are' do
    subject.to_version('1.2.3').must_equal "1.2.3"
    subject.to_version('(1,2)').must_equal "(1,2)"
    subject.to_version('[1,2)').must_equal "[1,2)"
    subject.to_version('(1,2]').must_equal "(1,2]"
    subject.to_version('[1,2]').must_equal "[1,2]"
  end

  it 'should convert pom of jar deps to maven coordinate' do
    subject.to_coordinate('something "a:b"').must_be_nil
    subject.to_coordinate('#jar "a:b"').must_be_nil
    subject.to_coordinate('jar "a:b" # bla').must_equal "a:b:jar:[0,)"
    subject.to_coordinate("pom 'b:c', '!2.3.4'").must_equal "b:c:pom:(2.3.4,)"
    subject.to_coordinate('jar "c:d", "2.3.4"').must_equal "c:d:jar:2.3.4"
    subject.to_coordinate("jar 'd:e', '~>1.8.2'").must_equal "d:e:jar:[1.8.2,1.8.99999]"
    subject.to_coordinate('pom "f:g", ">1.2", "<=2.0"').must_equal "f:g:pom:(1.2,2.0]"
    subject.to_coordinate('pom "e:f", "[1.8,1.9.9)"').must_equal "e:f:pom:[1.8,1.9.9)"
    subject.to_coordinate('pom "e:f", "(1.8,1.9.9)"').must_equal "e:f:pom:(1.8,1.9.9)"
    subject.to_coordinate('pom "e:f", "[1.8, 1.9.9]"').must_equal "e:f:pom:[1.8,1.9.9]"
  end

  it 'should support classifiers' do
    subject.to_coordinate('something "a:b:jdk15"').must_be_nil
    subject.to_coordinate('#jar "a:b:jdk15"').must_be_nil
    subject.to_coordinate('jar "a:b:jdk15" # bla').must_equal "a:b:jar:jdk15:[0,)"
    subject.to_coordinate("pom 'b:c:jdk15', '!2.3.4'").must_equal "b:c:pom:jdk15:(2.3.4,)"
    subject.to_coordinate('jar "c:d:jdk15", "2.3.4"').must_equal "c:d:jar:jdk15:2.3.4"
    subject.to_coordinate("jar 'd:e:jdk15', '~>1.8.2'").must_equal "d:e:jar:jdk15:[1.8.2,1.8.99999]"
    subject.to_coordinate('pom "f:g:jdk15", ">1.2", "<=2.0"').must_equal "f:g:pom:jdk15:(1.2,2.0]"
    subject.to_coordinate('pom "e:f:jdk15", "[1.8,1.9.9)"').must_equal "e:f:pom:jdk15:[1.8,1.9.9)"
    subject.to_coordinate('pom "e:f:jdk15", "(1.8,1.9.9)"').must_equal "e:f:pom:jdk15:(1.8,1.9.9)"
    subject.to_coordinate('pom "e:f:jdk15", "[1.8, 1.9.9]"').must_equal "e:f:pom:jdk15:[1.8,1.9.9]"
  end
end
