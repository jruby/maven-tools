#
# Copyright (C) 2014 Christian Meier
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require 'maven/tools/coordinate'
require 'maven/tools/versions'
require 'maven/tools/dsl/jruby_dsl'
require 'maven/tools/dsl/dependency_dsl'
module Maven
  module Tools
    module DSL
      class Gemspec

        def initialize( parent, name = nil, options = {} )
          @parent = parent
          case name
          when Hash
            options = name
            name = options[ 'name' ] || options[ :name ]
          when Gem::Specification
            process_gem_spec( name, options )
            return
          end
          name = find_gemspec_file( name )
          spec = gem_specification( name )
          name ||= "#{spec.name}-#{spec.version}.gemspec"
          process( spec, name, options )
        end

        attr_reader :parent

        def help
          warn "\n# Jarfile DSL #\n"
          warn self.class.help_block( :local => "path-to-local-jar", :jar => nil, :pom => nil, :repository => nil, :snapshot_repository => nil, :jruby => nil, :scope => nil)[0..-2]
        end

        def gem( scope, coord )
          DependencyDSL.create( @parent.current, :gem, scope, coord )
        end

        def jar( line )
          maven_dependency( "jar #{line}" )
        end

        def pom( line )
          maven_dependency( "pom #{line}" )
        end

        def method_missing( m, *args )
          if args.size == 1
            warn "unknown declaration: #{m} " + args[0]
          else
            super
          end
        end

        private

        include Maven::Tools::Coordinate

        def process_gem_spec( spec, options )
          if spec.spec_file
            name = File.basename( spec.spec_file )
          else
            name = nil
          end
          process( spec, name, options )
        end

        def find_gemspec_file( name )
          if name
            ::File.join( @parent.basedir, name )
          else
            gemspecs = Dir[ ::File.join( @parent.basedir, "*.gemspec" ) ]
            raise "more then one gemspec file found" if gemspecs.size > 1
            raise "no gemspec file found" if gemspecs.size == 0
            gemspecs.first
          end
        end

        def gem_specification( name )
          path = File.expand_path( name ) 
          spec_file = File.read( path )
          if spec_file.start_with?( '--- !ruby/object:Gem::Specification' )
            Gem::Specification.from_yaml( spec_file )
          else
            FileUtils.cd( @parent.basedir ) do
              return eval( spec_file, nil, path )
            end
          end
        end

        def process( spec, name, options )       
          if name
            config = { :gemspec => name.sub( /^#{@parent.basedir}\/?/, '' ) }
          end
          if options[ :include_jars ] || options[ 'include_jars' ] 
            config[ :includeDependencies ] = true
            config[ :useRepositoryLayout ] = true
            @parent.plugin :dependency do
              @parent.execute_goal( 'copy-dependencies',
                                    :phase => 'generate-test-resources',
                                    :outputDirectory => spec.require_path,
                                    :useRepositoryLayout => true )
            end
          end
          @parent.jruby_plugin!( :gem, config )

          gem_deps( spec, options ) unless options[ :no_gems ]
          other_deps( spec )
        end

        def gem_deps( spec, options )
          spec.dependencies.each do |dep|
            versions = dep.requirement.requirements.collect do |req|
              # use this construct to get the same result in 1.8.x and 1.9.x
              req.collect{ |i| i.to_s }.join
            end
            scope = dep.type == :development ? :test : nil
            gem( scope, "rubygems:#{dep.name}:#{to_version( *versions )}" )
          end
        end

        def other_deps( spec )
          spec.requirements.each do |req|
            req.sub!( /#.*^/, '' )
            method = req.sub(/\s.*$/, '' ).to_sym
            line = req.sub(/^[^\s]*\s/, '' )
            if respond_to? method
              if spec.platform.to_s == 'java'
                send method, line
              else
                warn "jar dependency found on non-java platform gem - ignoring: #{req}"
              end
            else
              warn "unknown declaration: #{req}"
            end
          end
        end

        def maven_dependency( line )
          coord = to_split_coordinate_with_scope( line )
          if coord && coord.size > 1
            DependencyDSL.create( @parent.current, nil, nil, *coord )
          end
        end
      end
    end
  end
end
