module Maven
  module Tools
    class Visitor

      def initialize( io = STDOUT )
        @io = io
      end

      def indent
        @indent ||= ''
      end

      def inc
        @indent = @indent + '  '
      end

      def dec
        @indent = @indent[ 0..-3 ]
      end

      def start_raw_tag( name, attr = {} )
        @io << "#{indent}<#{name}"
        attr.each do |k,v|
          @io << "\n"
          vv = v.gsub( /"/, '&quot;' )
          @io << "#{indent}  #{k.to_s[1..-1]}=\"#{vv}\""
        end
        @io << ">\n"
        inc
      end

      def end_raw_tag( name )
        dec
        @io << "#{indent}</#{name}>\n"
      end

      def start_tag( name, attr = {} )
        start_raw_tag( camel_case_lower( name ), attr )
      end

      def end_tag( name )
        end_raw_tag( camel_case_lower( name ) )
      end

      def tag( name, value )
        if value != nil
          if value.respond_to? :to_xml
            @io << "#{indent}#{value.to_xml}\n"
          else
            name = camel_case_lower( name )
            @io << "#{indent}<#{name}>#{escape_value( value )}</#{name}>\n"
          end
        end
      end

      def raw_tag( name, value )
        unless value.nil?
          @io << "#{indent}<#{name}>#{escape_value( value )}</#{name}>\n"
        end
      end

      def camel_case_lower( str )
        str = str.to_s
        str.split( '_' ).inject([]) do |buffer, e|
          buffer.push( buffer.empty? ? e : e.capitalize )
        end.join
      end

      def accept_project( project )
        accept( 'project', project )
        @io.close if @io.respond_to? :close
        nil
      end

      def accept( name, model )
        if model
          start_tag( name )
          visit( model )
          end_tag( name )
        end
      end

      def accept_array( name, array )
        unless array.empty?
          start_tag( name )
          n = name.to_s.sub( /ies$/, 'y' ).sub( /s$/, '' )
          case array.first
          when Maven::Tools::Base
            array.each do |i|
              start_tag( n )
              visit( i )
              end_tag( n )
            end
          when Hash
            array.each do |i|
              accept_hash( n, i )
            end
          else
            array.each do |i|
              tag( n, i )
            end
          end
          end_tag( name )
        end
      end

      def accept_raw_hash( name, hash )
        unless hash.empty?
          attr = hash.select do |k, v|
            [ k, v ] if k.to_s.match( /^@/ )
          end
          start_tag( name, attr )
          hash.each do |k, v|
            case v
            when Array
              accept_array( k, v )
            else
              raw_tag( k, v ) unless k.to_s.match( /^@/ )
            end
          end
          end_tag( name )
        end
      end

      def accept_hash( name, hash )
        unless hash.empty?
          attr = hash.select do |k, v|
            [ k, v ] if k.to_s.match( /^@/ )
          end
          # workaround error with :configuration => :gems => { ... }
          method = name == :gems ? :raw_tag : :tag

          start_tag( name, attr )
          hash.each do |k, v|
            case v
            when Array
              accept_array( k, v )
            when Hash
              accept_hash( k, v )
            else
              send( method, k, v ) unless k.to_s.match( /^@/ )
            end
          end
          end_tag( name )
        end
      end

      def escape_value( value )
        value = value.to_s.dup
        value.gsub!( /&/, '&amp;' )
        # undo double quote, somehow xyz.gemspec.rz have encoded values
        value.gsub!( /&amp;(amp|lt|gt);/, '&\1;' )
        value.gsub!( /</, '&lt;' )
        value.gsub!( />/, '&gt;' )
        value
      end

      def visit( model )
        model.attributes.each do |k, v|
          if k == :properties
            accept_raw_hash( k, v )
          else
            case v
            when Base
              accept( k, v )
            when Array
              accept_array( k, v )
            when Hash
              accept_hash( k, v )
            else
              tag( k, v )
            end
          end
        end
      end
    end
  end
end
