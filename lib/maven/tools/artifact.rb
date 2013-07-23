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
module Maven
  module Tools
    class Artifact < Hash

      def initialize( group_id, artifact_id, type,  
                      classifier = nil, version = nil, exclusions = nil,
                      options = {} )
        if exclusions.nil?
          if version.nil?
            version = classifier
            classifier = nil
          elsif version.is_a?( Array )
            exclusions = version
            version = classifier
            classifier = nil
          end
        end
        self[ :type ] = type
        self[ :group_id ] = group_id
        self[ :artifact_id ] = artifact_id
        self[ :version ] = version || "[0,)"
        self[ :classifier ] = classifier if classifier
        self[ :exclusions ] = exclusions if exclusions
        self.merge!( options ) if options
      end

      def gav_coordinate
        "#{self[:group_id]}:#{self[:artifact_id]}:#{self[:version]}"
      end

      def to_s
        [ self[:group_id], self[:artifact_id], self[:type], self[:classifier], self[:version], key?( :exclusions )? self[:exclusions].inspect.gsub( /[" ]/, '' ) : nil ].select { |o| o }.join( ':' )
      end
    end
  end
end
