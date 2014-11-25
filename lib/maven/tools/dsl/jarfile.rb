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
require 'maven/tools/dsl/dependency_dsl'
require 'maven/tools/dsl/jarfile_lock'
module Maven
  module Tools
    module DSL
      class Jarfile
        extend Options

        class ParentWithLock

          class Guarded < SimpleDelegator
            def initialize(deps, lock_file)
              super deps
              @lock = lock_file
            end
        
            def <<( d )
              unless @lock.locked?( "#{d.group_id}:#{d.artifact_id}" )
                super d
              end
            end
          end

          attr_reader :lock, :parent
         
          def initialize( parent, lock_file )
            @lock = lock_file
            @parent = parent
            # TODO remove case when parent is nil
            @deps = Guarded.new( parent ? parent.dependencies : [],
                                 lock_file )
          end

          def dependencies
            @deps
          end
        end

        def artifacts
          # TODO remove this part
          @artifacts ||= []
        end

        def repositories
          # TODO remove this part
          @repositories ||= []
        end
        
        def snapshot_repositories
          # TODO remove this part
          @snapshot_repositories ||= []
        end

        def initialize( parent, file = 'Jarfile', skip_lock = false )
          warn "DEPRECATED to have nil as parent" unless parent
          lockfile = JarfileLock.new( skip_lock ? nil : file )

          # the dependencies are only add if they are not locked
          @parent = ParentWithLock.new( parent, lockfile )

          # parse jarfile DSL
          eval( File.read( file ) )

          # fill dependencies from lockfile
          lockfile.coordinates.each do |d|
            a = Maven::Tools::Artifact.from_coordinate( d )
            add( a ) unless a[:systemPath]
          end
          scope( :test ) do
            lockfile.coordinates( :test ).each do |d|
              a = Maven::Tools::Artifact.from_coordinate( d )
              add( a ) unless a[:systemPath]
            end
          end
        end

        def add( artifact )
          dep = Dependency.new

          # use the fill_options to fill up the dependency
          self.class.fill_options( dep, artifact, :type )

          # adjust the scope
          dep.scope = @scope if @scope

          # use the original parent if present
          (@parent.parent || @parent ).dependencies << dep
        end

        def help
          warn "\n# Jarfile DSL #\n"
          warn self.class.help_block( :local => "path-to-local-jar", :jar => nil, :pom => nil, :repository => nil, :snapshot_repository => nil, :scope => nil)[0..-2]
        end

        def local( path )
          a = Artifact.new_local( ::File.expand_path( path ), :jar )
          add( a )
          # TODO remove this part
          artifacts << a
          a
        end

        def jar( *args, &block )
          a = DependencyDSL.create( @parent, :jar, @scope, *args, &block )
          # TODO remove this part
          artifacts << a
          a
        end

        def pom( *args, &block )
          a = DependencyDSL.create( @parent, :pom, @scope, *args, &block )
          # TODO remove this part
          artifacts << a
          a
        end

        def snapshot_repository( name, url = nil )
          if url.nil?
            url = name
          end
          snapshot_repositories << { :name => name.to_s, :url => url }
        end

        def repository( name, url = nil )
          if url.nil?
            url = name
          end
          repositories << { :name => name.to_s, :url => url }
        end
        alias :source :repository

        def scope( scope )
          @scope = scope
          yield if block_given?
        ensure
          @scope = nil
        end

        def jruby( *args, &block )
          warn "DEPRECATED jruby declaration has no effect anymore"
          # if args.empty? && !block
          #   @jruby ? @jruby.legacy_version : nil
          # else
          #   @jruby = JRubyDSL.create( @parent, :provided, *args, &block )
          # end
        end
      end
    end
  end
end
