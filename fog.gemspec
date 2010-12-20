require File.expand_path("../lib/fog/version", __FILE__)

Gem::Specification.new do |s|
  s.name          = "fog"
  s.version       = Fog::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["geemus (Wesley Beary)"]
  s.email         = 'geemus@gmail.com'
  s.homepage      = 'http://github.com/geemus/fog'
  s.summary       = "Brings clouds to you."
  s.description   = "The Ruby cloud computing library."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "fog"

  s.add_dependency('builder')
  s.add_dependency('excon', '>=0.3.3')
  s.add_dependency('formatador', '>=0.0.16')
  s.add_dependency('json')
  s.add_dependency('mime-types')
  s.add_dependency('net-ssh', '>=2.0.23')
  s.add_dependency('nokogiri', '>=1.4.4')
  s.add_dependency('ruby-hmac')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '1.3.1')
  s.add_development_dependency('shindo', '0.1.10')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = s.files.select { |path| path =~ /^[spec|tests]\/.*_[spec|tests]\.rb/ }
  s.executables   = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.default_executable = 'fog'
  s.require_paths = %w[lib]

  s.rdoc_options  = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.rdoc]
end