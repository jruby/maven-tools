require File.expand_path( 'spec_helper', File.dirname( __FILE__ ) )
require 'maven/tools/coordinate'
class A
  include Maven::Tools::Coordinate
end

describe Maven::Tools::Coordinate do

  subject { A.new }

  it 'should convert ruby version to maven version ranges' do
    _(subject.to_version).must_equal "[0,)"
    _(subject.to_version('!=2.3.4')).must_equal "(2.3.4,)"
    _(subject.to_version('!=2.3.4.rc')).must_equal "(2.3.4.rc-SNAPSHOT,)"
    _(subject.to_version('=2.3.4')).must_equal "[2.3.4,2.3.4.0.0.0.0.1)"
    _(subject.to_version('=2.3.4.alpha')).must_equal "2.3.4.alpha"
    _(subject.to_version('~>1.8.2')).must_equal "[1.8.2,1.8.99999]"
    _(subject.to_version('~>1.8.2.beta')).must_equal "[1.8.2.beta-SNAPSHOT,1.8.99999]"
    _(subject.to_version('~>1.8.2.beta123.12')).must_equal "[1.8.2.beta123.12-SNAPSHOT,1.8.99999]"
    _(subject.to_version('~>1.8.2.1beta')).must_equal "[1.8.2.1beta-SNAPSHOT,1.8.99999]"
    _(subject.to_version('~>1.8')).must_equal "[1.8,1.99999]"
    _(subject.to_version('~>0')).must_equal "[0,99999]"
    _(subject.to_version('>1.2')).must_equal "(1.2,)"
    _(subject.to_version('>1.2.GA')).must_equal "(1.2.GA-SNAPSHOT,)"
    _(subject.to_version('<1.2')).must_equal "[0,1.2)"
    _(subject.to_version('<1.2.dev')).must_equal "[0,1.2.dev-SNAPSHOT)"
    _(subject.to_version('>=1.2')).must_equal "[1.2,)"
    _(subject.to_version('>=1.2.gamma')).must_equal "[1.2.gamma-SNAPSHOT,)"
    _(subject.to_version('<=1.2')).must_equal "[0,1.2]"
    _(subject.to_version('<=1.2.pre')).must_equal "[0,1.2.pre-SNAPSHOT]"
    _(subject.to_version('>=1.2', '<2.0')).must_equal "[1.2,2.0)"
    _(subject.to_version('>=1.2', '<=2.0')).must_equal "[1.2,2.0]"
    _(subject.to_version('>1.2', '<2.0')).must_equal "(1.2,2.0)"
    _(subject.to_version('>1.2', '<=2.0')).must_equal "(1.2,2.0]"
  end

  it 'should keep maven version and ranges as they are' do
    _(subject.to_version('1.2.3')).must_equal "1.2.3"
    _(subject.to_version('(1,2)')).must_equal "(1,2)"
    _(subject.to_version('[1,2)')).must_equal "[1,2)"
    _(subject.to_version('(1,2]')).must_equal "(1,2]"
    _(subject.to_version('[1,2]')).must_equal "[1,2]"
  end

  it 'should keep maven snapshot version and ranges as they are' do
    _(subject.to_version('1.2.3-SNAPSHOT')).must_equal "1.2.3-SNAPSHOT"
    _(subject.to_version('(1,2-SNAPSHOT)')).must_equal "(1,2-SNAPSHOT)"
    _(subject.to_version('[1-SNAPSHOT,2)')).must_equal "[1-SNAPSHOT,2)"
    _(subject.to_version('(1,2-SNAPSHOT]')).must_equal "(1,2-SNAPSHOT]"
    _(subject.to_version('[1-SNAPSHOT,2]')).must_equal "[1-SNAPSHOT,2]"
  end

  it 'should convert pom of jar deps to maven coordinate' do
    _(subject.to_coordinate('something "a:b"')).must_be_nil
    _(subject.to_coordinate('#jar "a:b"')).must_be_nil
    _(subject.to_coordinate('jar "a:b" # bla')).must_equal "a:b:jar:[0,)"
    _(subject.to_coordinate("pom 'b:c', '!=2.3.4'")).must_equal "b:c:pom:(2.3.4,)"
    _(subject.to_coordinate('jar "c:d", "2.3.4"')).must_equal "c:d:jar:2.3.4"
    _(subject.to_coordinate("jar 'd:e', '~>1.8.2'")).must_equal "d:e:jar:[1.8.2,1.8.99999]"
    _(subject.to_coordinate('pom "f:g", ">1.2", "<=2.0"')).must_equal "f:g:pom:(1.2,2.0]"
    _(subject.to_coordinate('pom "e:f", "[1.8,1.9.9)"')).must_equal "e:f:pom:[1.8,1.9.9)"
    _(subject.to_coordinate('pom "e:f", "(1.8,1.9.9)"')).must_equal "e:f:pom:(1.8,1.9.9)"
    _(subject.to_coordinate('pom "e:f", "[1.8, 1.9.9]"')).must_equal "e:f:pom:[1.8,1.9.9]"
  end

  it 'should support classifiers' do
    _(subject.to_coordinate('something "a:b:jdk15"')).must_be_nil
    _(subject.to_coordinate('#jar "a:b:jdk15"')).must_be_nil
    _(subject.to_coordinate('jar "a:b:jdk15" # bla')).must_equal "a:b:jar:jdk15:[0,)"
    _(subject.to_coordinate("pom 'b:c:jdk15', '!=2.3.4'")).must_equal "b:c:pom:jdk15:(2.3.4,)"
    _(subject.to_coordinate('jar "c:d:jdk15", "2.3.4"')).must_equal "c:d:jar:jdk15:2.3.4"
    _(subject.to_coordinate("jar 'd:e:jdk15', '~>1.8.2'")).must_equal "d:e:jar:jdk15:[1.8.2,1.8.99999]"
    _(subject.to_coordinate('pom "f:g:jdk15", ">1.2", "<=2.0"')).must_equal "f:g:pom:jdk15:(1.2,2.0]"
    _(subject.to_coordinate('pom "e:f:jdk15", "[1.8,1.9.9)"')).must_equal "e:f:pom:jdk15:[1.8,1.9.9)"
    _(subject.to_coordinate('pom "e:f:jdk15", "(1.8,1.9.9)"')).must_equal "e:f:pom:jdk15:(1.8,1.9.9)"
    _(subject.to_coordinate('pom "e:f:jdk15", "[1.8, 1.9.9]"')).must_equal "e:f:pom:jdk15:[1.8,1.9.9]"
  end

  it 'supports declarations with scope' do
    _(subject.to_split_coordinate_with_scope('jar rubygems:ruby-maven, ~> 3.1.1.0, :scope => :provided')).must_equal [:provided, "rubygems", "ruby-maven", "jar", "[3.1.1.0,3.1.1.99999]"]
    _(subject.to_split_coordinate_with_scope("jar 'rubygems:ruby-maven', '~> 3.1.1.0', :scope => :test")).must_equal [:test, "rubygems", "ruby-maven", "jar", "[3.1.1.0,3.1.1.99999]"]
  end
end
