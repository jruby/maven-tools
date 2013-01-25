#
# Copyright (C) 2013 Christian Meier
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
require File.join(File.dirname(__FILE__), 'coordinate.rb')
module Maven
  module Tools

    class Jarfile
      include Coordinate

      def initialize(file = 'Jarfile')
        @file = file
        @lockfile = file + ".lock"
      end

      def mtime
        File.mtime(@file)
      end

      def exists?
        File.exists?(@file)
      end

      def mtime_lock
        File.mtime(@lockfile)
      end

      def exists_lock?
        File.exists?(@lockfile)
      end

      def load_lockfile
        _locked = []
        if exists_lock?
          File.read(@lockfile).each_line do |line|
            line.strip!
            if line.size > 0 && !(line =~ /^\s*#/)
              _locked << line
            end
          end
        end
        _locked
      end

      def locked
        @locked ||= load_lockfile
      end

      def locked?(coordinate)
        coord = coordinate.sub(/^([^:]+:[^:]+):.+/) { $1 }
        locked.detect { |l| l.sub(/^([^:]+:[^:]+):.+/) { $1 } == coord } != nil
      end

      def populate_unlocked(container)
        if File.exists?(@file)
          File.read(@file).each_line do |line| 
            if coord = to_coordinate(line)
              unless locked?(coord)
                container.add_artifact(coord)
              end
            elsif line =~ /^\s*(repository|source)\s/
              # allow `source :name, "http://url"`
              # allow `source "name", "http://url"`
              # allow `source "http://url"`
              # also allow `repository` instead of `source`
              name, url = line.sub(/.*(repository|source)\s+/, '').split(/,/)
              url = name unless url
              # remove whitespace and trailing/leading ' or "
              name.strip!
              name.gsub!(/^:/, '')
              name.gsub!(/^['"]|['"]$/,'')
              url.strip!
              url.gsub!(/^['"]|['"]$/,'')
              container.add_repository(name, url)
            end
          end
        end
      end

      def populate_locked(container)
        locked.each { |l| container.add_artifact(l) }
      end

      def generate_lockfile(dependency_coordinates)
        if dependency_coordinates.empty?
          FileUtils.rm_f(@lockfile) if exists_lock?
        else
          File.open(@lockfile, 'w') do |f|
            dependency_coordinates.each do |d|
              f.puts d.to_s unless d.to_s =~ /^ruby.bundler:/
            end
          end
        end
      end
    end

  end
end