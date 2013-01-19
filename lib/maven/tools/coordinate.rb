module Maven
  module Tools
    module Coordinate

      def to_coordinate(line)
        if line =~ /^\s*(jar|pom)\s/
          packaging = line.strip.sub(/\s+.*/, '')

          # Remove packaging, comments and whitespaces
          sanitized_line = line.sub(/\s*[a-z]+\s+/, '').sub(/#.*/,'').gsub(/\s+/,'')

          # Remove version(s) and quotes to find the group id, artifact id and classifier
          group_id, artifact_id, classifier = sanitized_line.split(',')[0].gsub(/['"]/, '').split(/:/)

          # Remove the group id, artifact id and classifier to find the version(s)
          version, second_version = sanitized_line.split(',')[1..-1].join(',').gsub(/['"],/, ':').gsub(/['"]/, '').split(/:/)
          mversion = second_version ? to_version(version, second_version) : to_version(version)

          classifier ? "#{group_id}:#{artifact_id}:#{packaging}:#{classifier}:#{mversion}" : "#{group_id}:#{artifact_id}:#{packaging}:#{mversion}"
        end
      end

      def group_artifact(*args)
        case args.size
        when 1
          name = args[0]
          if name =~ /:/
            [name.sub(/:[^:]+$/, ''), name.sub(/.*:/, '')]
          else
            ["rubygems", name]
          end
        else
          [args[0], args[1]]
        end
      end

      def gav(*args)
        if args[0] =~ /:/
          [args[0].sub(/:[^:]+$/, ''), args[0].sub(/.*:/, ''), maven_version(*args[1, 2])]
        else
          [args[0], args[1], maven_version(*args[2,3])]
        end
      end

      def to_version(*args)
        maven_version(*args) || "[0,)"
      end
      
      private

      def maven_version(*args)
        if args.size == 0 || (args.size == 1 && args[0].nil?)
          nil
        else
          low, high = convert(args[0])
          low, high = convert(args[1], low, high) if args[1] =~ /[=~><]/
          if low == high
            low
          else
            "#{low || '[0'},#{high || ')'}"
          end
        end
      end
      
      def convert(arg, low = nil, high = nil)
        if arg =~ /~>/
          val = arg.sub(/~>\s*/, '')
          last = val.sub(/\.[0-9]*[a-z]+.*$/, '').sub(/\.[^.]+$/, '.99999')
          ["[#{val}", "#{last}]"]
        elsif arg =~ />=/
          val = arg.sub(/>=\s*/, '')
          ["[#{val}", (nil || high)]
        elsif arg =~ /<=/
          val = arg.sub(/<=\s*/, '')
          [(nil || low), "#{val}]"]
          # treat '!' the same way as '>' since maven can not describe such range
        elsif arg =~ /[!>]/  
          val = arg.sub(/[!>]\s*/, '')
          ["(#{val}", (nil || high)]
        elsif arg =~ /</
          val = arg.sub(/<\s*/, '')
          [(nil || low), "#{val})"]
        elsif arg =~ /\=/
          val = arg.sub(/=\s*/, '')
          ["[" + val, val + '.0.0.0.0.1)']
        else
          [arg, arg]
        end
      end
    end
  end
end
