maven tools 
===========

* [![Build Status](https://github.com/jruby/maven-tools/actions/workflows/ci.yml/badge.svg)](https://github.com/jruby/maven-tools/actions/workflows/ci.yml)

Note on Ruby-1.8
----------------

ordering is important within the pom.xml since it carry info on the sequence of execution. jruby and ruby-1.9 do iterate in same order as the keys gets included, that helps to copy the order of declaration from the ruby DSL over to pom.xml. with ruby-1.8 the hash behaviour is different and since ruby-1.8 is end of life there is no support for ruby-1.8. though it might just works fine on simple setup.

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Building and releasing
----------------------

Specs can be run with `rake spec` but will also be run as part of maven test phase.

Build the gem with mvn package, making sure that both lib/maven-tools/version.rb and pom.xml are updated to the new
release version. The built gem will be in the pkg/ dir.

meta-fu
-------

enjoy :) 

