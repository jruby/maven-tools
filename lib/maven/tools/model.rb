require 'virtus'

module Maven
  module Tools
    class Base
    end

module GAV
  def self.included( base )
    base.attribute :group_id, String
    base.attribute :artifact_id, String
    base.attribute :version, String
  end
end
module GA
  def self.included( base )
    base.attribute :group_id, String
    base.attribute :artifact_id, String
  end
end
module SU
  def self.included( base )
    base.attribute :system, String
    base.attribute :url, String
  end
end
module NU
  def self.included( base )
    base.attribute :name, String
    base.attribute :url, String
  end
end
module INU
  def self.included( base )
    base.attribute :id, String
    base.attribute :name, String
    base.attribute :url, String
  end
end

class Parent < Base
  include Virtus.model

  include GAV

  attribute :relative_path, String
end
class Organization < Base
  include Virtus.model

  include NU
end
class License < Base
  include Virtus.model

  include NU
  attribute :distribution, String
  attribute :comments, String
end
class Developer < Base
  include Virtus.model

  include INU
  attribute :email, String
  attribute :organization, String
  attribute :organization_url, String
  attribute :roles, String
  attribute :timezone, String
  attribute :properties, Hash
end
class Contributor < Base
  include Virtus.model

  include NU
  attribute :email, String
  attribute :organization, String
  attribute :organization_url, String
  attribute :roles, String
  attribute :timezone, String
  attribute :properties, Hash
end
class MailingList < Base
  include Virtus.model

  attribute :name, String
  attribute :subscribe, String
  attribute :unsubscribe, String
  attribute :post, String
  attribute :archive, String
  attribute :other_archives, Array[ String ]
end
class Prerequisites < Base
  include Virtus.model

  attribute :maven, String
end
class Scm < Base
  include Virtus.model

  attribute :connection, String
  attribute :developer_connection, String
  attribute :tag, String
  attribute :url, String
end
class IssueManagement < Base
  include Virtus.model

  include SU
end
class Notifier < Base
  include Virtus.model
  
  attribute :type, String
  attribute :send_on_error, Boolean
  attribute :send_on_failure, Boolean
  attribute :send_on_success, Boolean
  attribute :send_on_warning, Boolean
  attribute :address, String
  attribute :configuration, Hash
end
class CiManagement < Base
  include Virtus.model

  include SU
  
  attribute :notifiers, Array[ Notifier ]
end
class Site < Base
  include Virtus.model

  include INU
end
class Relocation < Base
  include Virtus.model

  include GAV
  attribute :message, String
end
class RepositoryPolicy < Base
  include Virtus.model

  attribute :enabled, Boolean
  attribute :update_policy, String
  attribute :checksum_policy, String
end
class Repository < Base
  include Virtus.model

  attribute :unique_version, String
  attribute :releases, RepositoryPolicy
  attribute :snapshots, RepositoryPolicy

  include INU

  attribute :layout, String
end
class PluginRepository < Repository; end
class DeploymentRepository < Repository; end
class DistributionManagement < Base
  include Virtus.model

  attribute :repository, Repository
  attribute :snapshot_repository, Repository
  attribute :site, Site
  attribute :download_url, String
  attribute :status, String
  attribute :relocation, Relocation
end
class Exclusion < Base
  include Virtus.model

  include GA
end
class Dependency < Base
  include Virtus.model

  include GAV

  attribute :type, String
  attribute :classifier, String
  attribute :scope, String
  attribute :system_path, String
  attribute :exclusions, Array[ Exclusion ]
  attribute :optional, Boolean

  # silent default
  def type=( t )
    if t.to_sym == :jar
      @type = nil
    else
      @type = t
    end
  end
end
class DependencyManagement < Base
  include Virtus.model

  attribute :dependencies, Array[ Dependency ]
end
class Extension < Base
  include Virtus.model

  include GAV
end
class Resource < Base
  include Virtus.model

  attribute :target_path, String
  attribute :filtering, String
  attribute :directory, String
  attribute :includes, Array[ String ]
  attribute :excludes, Array[ String ]
end
class Execution < Base
  include Virtus.model

  attribute :id, String
  attribute :phase, String
  attribute :goals, Array[ String ]
  attribute :inherited, Boolean
  attribute :configuration, Hash
end
class Plugin < Base
  include Virtus.model

  include GAV
  attribute :extensions, Boolean
  attribute :executions, Array[ Execution ]
  attribute :dependencies, Array[ Dependency ]
  attribute :goals, Array[ String ]
  attribute :inherited, Boolean
  attribute :configuration, Hash

  # silent default
  def group_id=( v )
    if v.to_s == 'org.apache.maven.plugins'
      @group_id = nil
    else
      @group_id = v
    end
  end
end
class PluginManagement < Base
  include Virtus.model

  attribute :plugins, Array[ Plugin ]
end
class TestResource < Resource; end
class ReportSet < Base
  include Virtus.model

  attribute :id, String
  attribute :reports, Array[ String ]
  attribute :inherited, Boolean
  attribute :configuration, Hash
end
class ReportPlugin < Base
  include Virtus.model

  include GAV

  attribute :report_sets, Array[ ReportSet ]
end
class Reporting < Base
  include Virtus.model

  attribute :exclude_defaults, Boolean
  attribute :output_directory, String
  attribute :plugins, Array[ ReportPlugin ]
end
class Build < Base
  include Virtus.model

  attribute :source_directory, String
  attribute :script_source_directory, String
  attribute :test_source_directory, String
  attribute :output_directory, String
  attribute :test_output_directory, String
  attribute :extensions, Array[ Extension ]
  attribute :default_goal, String
  attribute :resources, Array[ Resource ]
  attribute :test_resources, Array[ TestResource ]
  attribute :directory, String
  attribute :final_name, String
  attribute :filters, Array[ String ]
  attribute :plugin_management, PluginManagement
  attribute :plugins, Array[ Plugin ]
end
class Os < Base
  include Virtus.model

  attribute :name, String
  attribute :family, String
  attribute :arch, String
  attribute :version, String
end
class Property < Base
  include Virtus.model

  attribute :name, String
  attribute :value, String
end
class ActivationFile < Base
  include Virtus.model

  attribute :missing, String
  attribute :exists, String
end
class Activation < Base
  include Virtus.model

  attribute :active_by_default, Boolean
  attribute :jdk, String
  attribute :os, Os
  attribute :property, Property
  attribute :file, ActivationFile
end
class Profile < Base
  include Virtus.model

  attribute :id, String
  attribute :activation, Activation
  attribute :build, Build
  attribute :modules, Array[ String ]
  attribute :distribution_management, DistributionManagement
  attribute :properties, Hash
  attribute :dependency_management, DependencyManagement
  attribute :dependencies, Array[ Dependency ]
  attribute :repositories, Array[ Repository ]
  attribute :plugin_repositories, Array[ PluginRepository ]
  attribute :reporting, Reporting
end
class Model < Base
  include Virtus.model

  attribute :model_version, String
  attribute :parent, Parent

  include GAV

  attribute :packaging, String

  include NU

  attribute :description, String
  attribute :inception_year, String
  attribute :organization, Organization
  attribute :licenses, Array[ License ]
  attribute :developers, Array[ Developer ]
  attribute :contributors, Array[ Contributor ]
  attribute :mailing_lists, Array[ MailingList ]
  attribute :prerequisites, Prerequisites
  attribute :modules, Array[ String ]
  attribute :scm, Scm
  attribute :issue_management, IssueManagement
  attribute :ci_management, CiManagement
  attribute :distribution_management, DistributionManagement
  attribute :properties, Hash
  attribute :dependency_management, DependencyManagement
  attribute :dependencies, Array[ Dependency ]
  attribute :repositories, Array[ Repository ]
  attribute :plugin_repositories, Array[ PluginRepository ]
  attribute :build, Build
  attribute :reporting, Reporting
  attribute :profiles, Array[ Profile ]
end
end
end
