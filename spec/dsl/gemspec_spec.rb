require_relative '../spec_helper'
require 'yaml'
require 'maven/tools/dsl/gemspec'
require 'maven/tools/project'
require 'maven/tools/model'
require 'maven/tools/dsl'
require 'maven/tools/visitor'

class Maven::Tools::Project
  include Maven::Tools::DSL
end

class GemspecFile
  def self.read( name, artifact_id )
    xml = File.read( __FILE__.sub( /.rb$/, "/#{name}" ) )
    xml.gsub!( /BASEDIR/, artifact_id )
    xml
  end

end

describe Maven::Tools::DSL::Gemspec do

  let( :parent ) { Maven::Tools::Project.new( __FILE__.sub( /.rb$/, '/maven-tools.gemspec' ) ) }

  subject { Maven::Tools::DSL::Gemspec }

  it 'evals maven_tools.gemspec' do
    parent = Maven::Tools::Project.new
    subject.new parent
    xml = ""
    Maven::Tools::Visitor.new( xml ).accept_project( parent.model )
    xml.must_equal( GemspecFile.read( 'maven-tools.xml', 'maven-tools'  ) )
  end

  it 'evals maven_tools.gemspec from yaml' do
    subject.new parent, 'maven-tools.gemspec'
    xml = ""
    Maven::Tools::Visitor.new( xml ).accept_project( parent.model )
    xml.must_equal( GemspecFile.read( 'maven-tools.xml', 'gemspec_spec' ) )
  end

  it 'evals gemspec with jar and pom dependencies' do
    subject.new parent, 'jars_and_poms.gemspec'
    xml = ""
    Maven::Tools::Visitor.new( xml ).accept_project( parent.model )
    xml.must_equal( GemspecFile.read( 'jars_and_poms.xml',
                                  'gemspec_spec' ) )
  end

  it 'evals gemspec with jar and pom dependencies' do
    subject.new parent, :name => 'jars_and_poms.gemspec', :include_jars => true
    xml = ""
    Maven::Tools::Visitor.new( xml ).accept_project( parent.model )
    xml.must_equal( GemspecFile.read( 'jars_and_poms_include_jars.xml',
                                  'gemspec_spec' ) )
  end
end
