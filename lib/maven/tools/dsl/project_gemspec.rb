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
require 'maven/tools/dsl/gemspec'
require 'maven/tools/dsl/gem_support'
require 'maven/tools/licenses'
module Maven
  module Tools
    module DSL
      class ProjectGemspec < Gemspec

        include GemSupport

        def process( spec, name, options )
          @parent.build.directory = '${basedir}/pkg'
          version = spec.version.to_s
          if spec.version.prerelease? && options[ :snapshot ] != false
            version += '-SNAPSHOT'
          end
          @parent.id "rubygems:#{spec.name}:#{version}"
          @parent.name( spec.summary || spec.name )
          @parent.description spec.description
          @parent.url spec.homepage
          if spec.homepage && spec.homepage.match( /github.com/ )
            con = spec.homepage.sub( /http:/, 'https:' ).sub( /\/?$/, ".git" )
            @parent.scm :url => spec.homepage, :connection => con
          end

          spec.licenses.each do |l|
            if Maven::Tools::LICENSES.include?(l.downcase)
              lic = Maven::Tools::LICENSES[ l.downcase ]
              @parent.license( :name => lic.short,
                               :url => lic.url,
                               :comments => lic.name )
            else
              @parent.license( l )
            end
          end
          authors = [ spec.authors || [] ].flatten
          emails = [ spec.email || [] ].flatten
          authors.zip( emails ).each do |d|
            @parent.developer( :name => d[0], :email => d[1] )
          end
  
          @parent.packaging 'gem'
          if setup_gem_support( @parent, options, spec )
            @parent.extension 'de.saumya.mojo:gem-with-jar-extension:${jruby.plugins.version}'
          else
            @parent.extension 'de.saumya.mojo:gem-extension:${jruby.plugins.version}'
          end
          super
        end

        def gem_deps( spec, options )
          if options[:profile]
            @parent.profile! options[:profile] do
              super
            end
          else
            super
          end
        end

        def help
          warn "\n# Jarfile DSL #\n"
          warn self.class.help_block( :local => "path-to-local-jar", :jar => nil, :pom => nil, :repository => nil, :snapshot_repository => nil, :jruby => nil, :scope => nil)[0..-2]
        end
      end
    end
  end
end
