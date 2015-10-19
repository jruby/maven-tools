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
      class JarsLock
 
        def initialize( parent, file = 'Jars.lock' )
          file = File.join( parent.basedir, file )
          if File.exists?(file)
            parent.profile File.basename(file) do
              parent.activation do
                parent.file( :exists => File.basename(file) )
              end
              File.read(file).each_line do |line|
                data = line.sub(/-\ /, '').strip.split(':')
                case data.size
                when 3
                  data = Hash[ [:groupId, :artifactId, :version].zip( data ) ]
                  parent.jar data[:groupId], data[:artifactId], data[:version], :scope => :compile
                when 4
                  data = Hash[ [:groupId, :artifactId, :version, :scope].zip( data ) ]
                  parent.jar data[:groupId], data[:artifactId], data[:version], :scope => data[:scope]
                when 5
                  data = Hash[ [:groupId, :artifactId, :classifier, :version, :scope].zip( data ) ]
                  parent.jar data[:groupId], data[:artifactId], data[:version], :classifier => data[:classifier], :scope => data[:scope]
                else
                  warn "can not parse: #{line}"
                end
              end
            end
          end
        end

        def help
          warn "\n# jars.lock(file) - default JArs.lock #\n"
        end

      end
    end
  end
end
