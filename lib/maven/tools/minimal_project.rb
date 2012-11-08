# TODO make nice require after ruby-maven uses the same ruby files
require 'maven/model/model'
require 'maven/tools/versions'

module Maven
  module Tools

    class MinimalProject < Maven::Model::Project
      tags :dummy

      def self.create( gemfile, &block )
        require 'rubygems'
        require 'rubygems/format'
        self.new( Gem::Format.from_file_by_path( gemfile ).spec )
      end

      def initialize( spec, &block )
        super( "rubygems", spec.name, spec.version, &block )

        packaging "gem"

        name spec.summary || "#{self.artifact_id} - gem"
        description spec.description if spec.description
        url spec.homepage if spec.homepage
        ( [spec.email].flatten || [] ).zip( [spec.authors].flatten || [] ).map do |email, author|
          self.developers.new( author, email )
        end

        #  TODO work with collection of licenses - there can be more than one !!!
        ( spec.licenses + spec.files.select {|file| file.to_s =~ /license|gpl/i } ).each do |license|
          # TODO make this better, i.e. detect the right license name from the file itself
          self.licenses.new( license )
        end

        plugin('gem', VERSIONS[:jruby_plugins]) do |g|
          g.extensions = true
        end

        spec.dependencies.each do |dep|
          versions = dep.requirement.requirements.collect do |req|
            # use this construct to get the same result in 1.8.x and 1.9.x
            req.collect{ |i| i.to_s }.join
          end
          g = gem( dep.name, versions )
          g.scope = 'test' if dep.type == :development
        end

        spec.requirements.each do |req|
          req.split( /\n/ ).each do |r|
            coord = to_coordinate( r )
            if coord 
              name = coord.sub(/:[^:]+:[^:]+$/, '')
              versions = coord.sub(/.*:/, '')
              if r =~ /^\s*(jar|pom)\s/
                jar( name, versions )
              end
            end
          end
        end
      end
    end
  end
end
