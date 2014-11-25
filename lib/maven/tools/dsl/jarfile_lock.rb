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
require 'fileutils'
require 'yaml'
module Maven
  module Tools
    module DSL
      class JarfileLock
        
        def initialize( jarfile )
          @file = File.expand_path( jarfile + ".lock" ) if jarfile
          if @file && File.exists?( @file )
            lock = YAML.load( File.read( @file ) )
            if lock.is_a? Hash
              @data = lock
            else
              # fallback on old format and treat them all as "runtime"
              data[ :runtime ] = lock.split( /\ / )
            end
          end
        end
        
        def dump
          if @data and not @data.empty?
            File.write( @file, @data.to_yaml )
          else
            FileUtils.rm_f( @file )
          end
        end

        def coordinates( scope = :runtime )
          data[ scope ] || []
        end

        def replace( deps )
          data.clear
          @all = nil
          update_unlocked( deps )
        end

        def update_unlocked( deps )
          success = true
          deps.each do |k,v|
            bucket = ( data[ k ] ||= [] )
            v.each do |e|
              # TODO remove check and use only e.coord
              coord = e.respond_to?( :coord ) ? e.coord : e
              if exists?( coord )
                # do nothing
              elsif locked?( coord )
                # mark result as conflict
                success = false
              else
                # add it
                if not e.respond_to?( :coord ) && e.gav =~ /system$/
                  bucket << coord
                end
              end
            end
          end
          @all = nil
          success
        end

        def exists?( coordinate )
          all.member?( coordinate )
        end

        def locked?( coordinate )
          coord = coordinate.sub(/^([^:]+:[^:]+):.+/) { $1 }
          all.detect do |l|
            l.sub(/^([^:]+:[^:]+):.+/) { $1 } == coord 
          end != nil
        end

        private
        
        def all
          @all ||= coordinates( :runtime ) + coordinates( :test )
        end

        def data
          @data ||= {}
        end        
      end
    end
  end
end
