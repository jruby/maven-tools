require_relative '../spec_helper'
require 'yaml'
require 'maven/tools/dsl/profile_gemspec'
require 'maven/tools/project'
require 'maven/tools/model'
require 'maven/tools/dsl'
require 'maven/tools/version'
require 'maven/tools/visitor'

class Maven::Tools::Project
  include Maven::Tools::DSL
end

class ProfileGemspecFile
  def self.read( name, artifact_id, version = '1.0.5' )
    xml = File.read( __FILE__.sub( /.rb$/, "/#{name}" ) )
    xml.gsub!( /BASEDIR/, artifact_id )
    xml.gsub!( /VERSION/, version )
    xml
  end

end

describe Maven::Tools::DSL::ProfileGemspec do

  let( :parent ) { Maven::Tools::Project.new( __FILE__.sub( /.rb$/, '/maven-tools.gemspec' ) ) }

  subject { Maven::Tools::DSL::ProfileGemspec }

  it 'evals maven_tools.gemspec' do
    parent = Maven::Tools::Project.new
    subject.new parent
    xml = ""
    Maven::Tools::Visitor.new( xml ).accept_project( parent.model )
    v = Maven::Tools::VERSION
    v += '-SNAPSHOT' if v =~ /.dev$/
    xml.must_equal( ProfileGemspecFile.read( 'maven-tools.xml', 'maven-tools',
                                  v ) )
  end

  it 'evals maven_tools.gemspec from yaml' do
    subject.new parent, 'maven-tools.gemspec'
    xml = ""
    Maven::Tools::Visitor.new( xml ).accept_project( parent.model )
    xml.must_equal( ProfileGemspecFile.read( 'maven-tools.xml', 'profile_gemspec_spec' ) )
  end

  it 'evals maven_tools.gemspec from yaml no gem dependencies' do
    subject.new parent, 'maven-tools.gemspec', :no_gems => true
    xml = ""
    Maven::Tools::Visitor.new( xml ).accept_project( parent.model )
    xml.must_equal( ProfileGemspecFile.read( 'no_gems.xml', 'gemspec_spec' ) )
  end

  it 'evals snapshot.gemspec' do
    subject.new parent, 'snapshot.gemspec'
    xml = ""
    Maven::Tools::Visitor.new( xml ).accept_project( parent.model )
    xml.must_equal( ProfileGemspecFile.read( 'snapshot.xml', 'snapshot', '1.a-SNAPSHOT' ) )
  end

  it 'evals gemspec with jar and pom dependencies' do
    subject.new parent, 'jars_and_poms.gemspec'
    xml = ""
    Maven::Tools::Visitor.new( xml ).accept_project( parent.model )
    xml.must_equal( ProfileGemspecFile.read( 'jars_and_poms.xml',
                                  'gemspec_spec' ) )
  end

  it 'evals gemspec with jar and pom dependencies' do
    subject.new parent, :name => 'jars_and_poms.gemspec', :include_jars => true
    xml = ""
    Maven::Tools::Visitor.new( xml ).accept_project( parent.model )
    xml.must_equal( ProfileGemspecFile.read( 'jars_and_poms_include_jars.xml',
                                             'gemspec_spec' ) )
  end

  it 'evals gemspec without previously known license' do
    subject.new parent, 'unknown_license.gemspec'
    xml = ""
    Maven::Tools::Visitor.new( xml ).accept_project( parent.model )
    xml.must_equal( ProfileGemspecFile.read( 'unknown_license.xml', 'gemspec_spec' ) )
  end
end
