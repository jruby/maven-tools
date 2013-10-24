begin
  require 'minitest'
rescue LoadError
end
require 'minitest/autorun'

$LOAD_PATH.unshift File.join( File.dirname( File.expand_path( __FILE__ ) ),
                              '..', 'lib' )
