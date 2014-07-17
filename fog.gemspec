Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'fog'
  s.version           = '1.23.0'
  s.date              = '2014-07-17'
  s.rubyforge_project = 'fog'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "brings clouds to you"
  s.description = "The Ruby cloud services library. Supports all major cloud providers including AWS, Rackspace, Linode, Blue Box, StormOnDemand, and many others. Full support for most AWS services including EC2, S3, CloudWatch, SimpleDB, ELB, and RDS."

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["geemus (Wesley Beary)"]
  s.email    = 'geemus@gmail.com'
  s.homepage = 'http://github.com/fog/fog'
  s.license  = 'MIT'

  ## This sections is only necessary if you have C extensions.
  # s.require_paths << 'ext'
  # s.extensions = %w[ext/extconf.rb]

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib]

  ## If your gem includes any executables, list them here.
  s.executables = ["fog"]

  ## Specify any RDoc options here. You'll want to add your README and
  ## LICENSE files to the extra_rdoc_files list.
  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md]

  ## List your runtime dependencies here. Runtime dependencies are those
  ## that are needed for an end user to actually USE your code.
  s.add_dependency("fog-core", "~> 1.23")
  s.add_dependency("fog-json")

  s.add_dependency('nokogiri', '~> 1.5', '>= 1.5.11')
  s.add_dependency('ipaddress', '~>0.5')

  # Modular providers
  s.add_dependency("fog-brightbox")
  s.add_dependency("fog-softlayer")

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  s.add_development_dependency('minitest')
  s.add_development_dependency('rake')
  s.add_development_dependency('rbvmomi')
  s.add_development_dependency('yard')
  s.add_development_dependency('thor')
  s.add_development_dependency('rbovirt', '0.0.24')
  s.add_development_dependency('shindo', '~> 0.3.4')
  s.add_development_dependency('fission')
  s.add_development_dependency('pry')
  s.add_development_dependency('opennebula', '>=4.4.0')
  s.add_development_dependency('google-api-client', '~> 0.6', '>= 0.6.2')
  s.add_development_dependency('rubocop') if RUBY_VERSION > "1.9"

  if ENV["FOG_USE_LIBVIRT"]
    s.add_development_dependency('ruby-libvirt','~> 0.5.0')
  end

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec,tests}/*`.split("\n")
end
