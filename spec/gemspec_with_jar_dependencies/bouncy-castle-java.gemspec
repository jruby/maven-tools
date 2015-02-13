#-*- mode: ruby -*-

Gem::Specification.new do |s|
  s.name = 'bouncy-castle-java'
  s.version = "1.5.0"
  s.author = 'Hiroshi Nakamura'
  s.email = 'nahi@ruby-lang.org'

  s.homepage = 'http://github.com/jruby/jruby/tree/master/gems/bouncy-castle-java/'
  s.summary = 'Gem redistribution of Bouncy Castle jars'
  s.licenses = [ 'EPL-1.0', 'GPL-2.0', 'LGPL-2.1' ]

  s.description = 'Gem redistribution of "Legion of the Bouncy Castle Java cryptography APIs" jars at http://www.bouncycastle.org/java.html'
  s.platform = 'java'

  s.requirements << "jar org.bouncycastle:bcpkix-jdk15on, 1.2.3"
  s.requirements << "jar org.bouncycastle:bcprov-jdk15on, 1.2.3, :scope => :test"
end

# vim: syntax=Ruby
