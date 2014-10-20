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
module Maven
  module Tools
    module DSL
      module GemSupport 

        def setup_jruby_plugins_version( project )
          if not @parent.properties.key?( 'jruby.plugins.version' ) and
              not project.properties.key?( 'jruby.plugins.version' )
            @parent.properties( 'jruby.plugins.version' => VERSIONS[ :jruby_plugins ] )
          end
        end

        def setup_gem_support( project, options, spec = nil )
          unless project.properties.member?( 'project.build.sourceEncoding' )
            @parent.properties( 'project.build.sourceEncoding' => 'utf-8' )
          end
          if spec.nil?
            require_path = '.'
            name = ::File.basename( ::File.expand_path( '.' ) )
          else
            require_path = spec.require_path
            name = spec.name
          end

          if ( nil == project.current.repositories.detect { |r| r.id == 'rubygems-releases' } && options[ :no_rubygems_repo ] != true )
              
            @parent.repository( 'rubygems-releases',
                                'http://rubygems-proxy.torquebox.org/releases' )
          end
          @parent.needs_torquebox = true
            
          setup_jruby_plugins_version( project )
          
          if options.key?( :jar ) || options.key?( 'jar' )
            jarpath = options[ :jar ] || options[ 'jar' ]
            if jarpath
              jar = ::File.basename( jarpath ).sub( /.jar$/, '' )
              output = ::File.dirname( "#{require_path}/#{jarpath}" )
              output.sub!( /\/$/, '' )
            end
          else
            jar = "#{name}"
            output = "#{require_path}"
          end
          if options.key?( :source ) || options.key?( 'source' )
            source = options[ :source ] || options[ 'source' ]
            @parent.build do
              @parent.source_directory source
            end
          end
          # TODO rename "no_rubygems_repo" to "no_jar_support"
          if(  options[ :no_rubygems_repo ] != true && 
               jar &&
               ( source || File.exists?( File.join( project.basedir, 
                                                    'src/main/java' ) ) ) )
            
            unless spec.nil? || spec.platform.to_s.match( /java|jruby/ )
              warn "gem is not a java platform gem but has a jar and source"
            end
            
            @parent.plugin( :jar, VERSIONS[ :jar_plugin ],
                            :outputDirectory => output,
                            :finalName => jar ) do
              @parent.execute_goals :jar, :phase => 'prepare-package'
            end
            @parent.plugin( :clean, VERSIONS[ :clean_plugin ],
                            :filesets => [ { :directory => output,
                                             :includes => [ "#{jar}.jar", '*/**/*.jar' ] } ] )
            true
          else
            false
          end
        end
      end
    end
  end
end
