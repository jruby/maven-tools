require 'dry-types'
require 'dry-struct'
require 'dry/struct/with_setters'

# keep things in line with java collections
class Array
  def remove( *args )
    delete( *args )
  end
end

module Types
  include Dry.Types()
end

module Maven
  module Tools
    class Base < Dry::Struct::WithSetters
      transform_keys(&:to_sym)
    end

    class GAV < Base
      attribute? :group_id, Types::Coercible::String.optional
      attribute? :artifact_id, Types::Coercible::String.optional
      attribute? :version, Types::Coercible::String.optional
    end
    class GA < Base
      attribute? :group_id, Types::Coercible::String.optional
      attribute? :artifact_id, Types::Coercible::String.optional
    end
    class SU < Base
      attribute? :system, Types::Coercible::String.optional
      attribute? :url, Types::Coercible::String.optional
    end
    class NU < Base
      attribute? :name, Types::Coercible::String.optional
      attribute? :url, Types::Coercible::String.optional
    end
    class INU < Base
      attribute? :id, Types::Coercible::String.optional
      attribute? :name, Types::Coercible::String.optional
      attribute? :url, Types::Coercible::String.optional
    end

    class Parent < GAV
      attribute? :relative_path, Types::Coercible::String.optional
    end
    class Organization < NU; end
    class License < NU
      attribute? :distribution, Types::Coercible::String.optional
      attribute? :comments, Types::Coercible::String.optional
    end
    class Developer < INU
      attribute? :email, Types::Coercible::String.optional
      attribute? :organization, Types::Coercible::String.optional
      attribute? :organization_url, Types::Coercible::String.optional
      attribute? :roles, Types::Array.of(Types::Coercible::String).default { Array.new }
      attribute? :timezone, Types::Coercible::String.optional
      attribute? :properties, Types::Hash.default { Hash.new }
    end
    class Contributor < NU
      attribute? :email, Types::Coercible::String.optional
      attribute? :organization, Types::Coercible::String.optional
      attribute? :organization_url, Types::Coercible::String.optional
      attribute? :roles, Types::Array.of(Types::Coercible::String).default { Array.new }
      attribute? :timezone, Types::Coercible::String.optional
      attribute? :properties, Types::Hash.default { Hash.new }
    end
    class MailingList < Base
      attribute? :name, Types::Coercible::String.optional
      attribute? :subscribe, Types::Coercible::String.optional
      attribute? :unsubscribe, Types::Coercible::String.optional
      attribute? :post, Types::Coercible::String.optional
      attribute? :archive, Types::Coercible::String.optional
      attribute? :other_archives, Types::Array.of(Types::Coercible::String).default { Array.new }

      def archives=( archives )
        self.archive = archives.shift
        self.other_archives = archives
      end
    end
    class Prerequisites < Base
      attribute? :maven, Types::Coercible::String.optional
    end
    class Scm < Base
      attribute? :connection, Types::Coercible::String.optional
      attribute? :developer_connection, Types::Coercible::String.optional
      attribute? :tag, Types::Coercible::String.optional
      attribute? :url, Types::Coercible::String.optional
    end
    class IssueManagement < SU
    end
    class Notifier < Base
      attribute? :type, Types::Coercible::String.optional
      attribute? :send_on_error, Types::Params::Bool
      attribute? :send_on_failure, Types::Params::Bool
      attribute? :send_on_success, Types::Params::Bool
      attribute? :send_on_warning, Types::Params::Bool
      attribute? :address, Types::Coercible::String.optional
      attribute? :configuration, Types::Hash.default { Hash.new }
    end
    class CiManagement < SU
      attribute? :notifiers, Types::Array.of( Notifier ).default { Array.new }
    end
    class Site < INU
    end
    class Relocation < GAV
      attribute? :message, Types::Coercible::String.optional
    end
    class RepositoryPolicy < Base
      attribute? :enabled, Types::Params::Bool
      attribute? :update_policy, Types::Coercible::String.optional
      attribute? :checksum_policy, Types::Coercible::String.optional
    end
    class Repository < INU
      attribute? :releases, RepositoryPolicy.optional
      attribute? :snapshots, RepositoryPolicy.optional
      attribute? :layout, Types::Coercible::String.optional
    end
    class PluginRepository < Repository; end
    class DeploymentRepository < Repository; end
    class DistributionManagement < Base
      attribute? :repository, Repository.optional
      attribute? :snapshot_repository, Repository.optional
      attribute? :site, Site.optional
      attribute? :download_url, Types::Coercible::String.optional
      attribute? :status, Types::Coercible::String.optional
      attribute? :relocation, Relocation.optional
    end
    class Exclusion < GA; end
    class Dependency < Base
      attribute? :group_id, Types::Coercible::String.optional
      attribute? :artifact_id, Types::Coercible::String.optional
      attribute? :version, Types::Coercible::String.optional
      attribute? :type, Types::Coercible::String.optional
      attribute? :classifier, Types::Coercible::String.optional
      attribute? :scope, Types::Coercible::String.optional
      attribute? :system_path, Types::Coercible::String.optional
      attribute? :exclusions, Types::Array.of( Exclusion ).default { Array.new }
      attribute? :optional, Types::Params::Bool

      # silent default
      def type=( t )
        if t.to_sym == :jar
          @attributes['type']  = nil
        else
          @attributes['type']  = t
        end
      end
    end
    class DependencyManagement < Base
      attribute? :dependencies, Types::Array.of( Dependency ).default { Array.new }
    end
    class Extension < GAV; end
    class Resource < Base
      attribute? :target_path, Types::Coercible::String.optional
      attribute? :filtering, Types::Coercible::String.optional
      attribute? :directory, Types::Coercible::String.optional
      attribute? :includes, Types::Array.of(Types::Coercible::String).default { Array.new }
      attribute? :excludes, Types::Array.of(Types::Coercible::String).default { Array.new }
    end
    class Execution < Base
      attribute? :id, Types::Coercible::String.optional
      attribute? :phase, Types::Coercible::String.optional
      attribute? :goals, Types::Array.of(Types::Coercible::String).default { Array.new }
      attribute? :inherited, Types::Params::Bool
      attribute? :configuration, Types::Hash.default { Hash.new }
    end
    class Plugin < Base
      attribute? :group_id, Types::Coercible::String.optional
      attribute? :artifact_id, Types::Coercible::String.optional
      attribute? :version, Types::Coercible::String.optional
      attribute? :extensions, Types::Params::Bool
      attribute? :executions, Types::Array.of( Execution ).default { Array.new }
      attribute? :dependencies, Types::Array.of( Dependency ).default { Array.new }
      attribute? :goals, Types::Array.of(Types::Coercible::String).default { Array.new }
      attribute? :inherited, Types::Params::Bool
      attribute? :configuration, Types::Hash.default { Hash.new }

      # silent default
      def group_id=( v )
        if v.to_s == 'org.apache.maven.plugins'
          @attributes['group_id'] = nil
        else
          @attributes['group_id'] = v
        end
      end
    end
    class PluginManagement < Base
      attribute? :plugins, Types::Array.of( Plugin ).default { Array.new }
    end
    class ReportSet < Base
      attribute? :id, Types::Coercible::String.optional
      attribute? :reports, Types::Array.of(Types::Coercible::String).default { Array.new }
      attribute? :inherited, Types::Params::Bool
      attribute? :configuration, Types::Hash.default { Hash.new }
    end
    class ReportPlugin < GAV
      attribute? :report_sets, Types::Array.of( ReportSet ).default { Array.new }
    end
    class Reporting < Base
      attribute? :exclude_defaults, Types::Params::Bool
      attribute? :output_directory, Types::Coercible::String.optional
      attribute? :plugins, Types::Array.of( ReportPlugin ).default { Array.new }
    end
    class Build < Base
      attribute? :source_directory, Types::Coercible::String.optional
      attribute? :script_source_directory, Types::Coercible::String.optional
      attribute? :test_source_directory, Types::Coercible::String.optional
      attribute? :output_directory, Types::Coercible::String.optional
      attribute? :test_output_directory, Types::Coercible::String.optional
      attribute? :extensions, Types::Array.of( Extension ).default { Array.new }
      attribute? :default_goal, Types::Coercible::String.optional
      attribute? :resources, Types::Array.of( Resource ).default { Array.new }
      attribute? :test_resources, Types::Array.of(  Resource  ).default { Array.new }
      attribute? :directory, Types::Coercible::String.optional
      attribute? :final_name, Types::Coercible::String.optional
      attribute? :filters, Types::Array.of(Types::Coercible::String).default { Array.new }
      attribute? :plugin_management, PluginManagement.optional
      attribute? :plugins, Types::Array.of( Plugin ).default { Array.new }
    end
    class ActivationOS < Base
      attribute? :name, Types::Coercible::String.optional
      attribute? :family, Types::Coercible::String.optional
      attribute? :arch, Types::Coercible::String.optional
      attribute? :version, Types::Coercible::String.optional
    end
    class ActivationProperty < Base
      attribute? :name, Types::Coercible::String.optional
      attribute? :value, Types::Coercible::String.optional
    end
    class ActivationFile < Base
      attribute? :missing, Types::Coercible::String.optional
      attribute? :exists, Types::Coercible::String.optional
    end
    class Activation < Base
      attribute? :active_by_default, Types::Params::Bool
      attribute? :jdk, Types::Coercible::String.optional
      attribute? :os, ActivationOS.optional
      attribute? :property, ActivationProperty.optional
      attribute? :file, ActivationFile.optional
    end
    class Profile < Base
      attribute? :id, Types::Coercible::String.optional
      attribute? :activation, Activation.optional
      attribute? :build, Build.optional
      attribute? :modules, Types::Array.of(Types::Coercible::String).default { Array.new }
      attribute? :distribution_management, DistributionManagement.optional
      attribute? :properties, Types::Hash.default { Hash.new }
      attribute? :dependency_management, DependencyManagement.optional
      attribute? :dependencies, Types::Array.of( Dependency ).default { Array.new }
      attribute? :repositories, Types::Array.of( Repository ).default { Array.new }
      attribute? :plugin_repositories, Types::Array.of( PluginRepository ).default { Array.new }
      attribute? :reporting, Reporting.optional
    end
    class Model < Base
      attribute? :model_version, Types::Coercible::String.optional
      attribute? :parent, Parent.optional

      attribute? :group_id, Types::Coercible::String.optional
      attribute? :artifact_id, Types::Coercible::String.optional
      attribute? :version, Types::Coercible::String.optional

      attribute? :packaging, Types::Coercible::String.optional

      attribute? :name, Types::Coercible::String.optional
      attribute? :url, Types::Coercible::String.optional

      attribute? :description, Types::Coercible::String.optional
      attribute? :inception_year, Types::Coercible::String.optional
      attribute? :organization, Organization.optional
      attribute? :licenses, Types::Array.of( License ).default { Array.new }
      attribute? :developers, Types::Array.of( Developer ).default { Array.new }
      attribute? :contributors, Types::Array.of( Contributor ).default { Array.new }
      attribute? :mailing_lists, Types::Array.of( MailingList ).default { Array.new }
      attribute? :prerequisites, Prerequisites.optional
      attribute? :modules, Types::Array.of(Types::Coercible::String).default { Array.new }
      attribute? :scm, Scm.optional
      attribute? :issue_management, IssueManagement.optional
      attribute? :ci_management, CiManagement.optional
      attribute? :distribution_management, DistributionManagement.optional
      attribute? :properties, Types::Hash.default { Hash.new }
      attribute? :dependency_management, DependencyManagement.optional
      attribute? :dependencies, Types::Array.of( Dependency ).default { Array.new }
      attribute? :repositories, Types::Array.of( Repository ).default { Array.new }
      attribute? :plugin_repositories, Types::Array.of( PluginRepository ).default { Array.new }
      attribute? :build, Build.optional
      attribute? :reporting, Reporting.optional
      attribute? :profiles, Types::Array.of( Profile ).default { Array.new }
    end
  end
end
