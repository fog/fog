# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fog/version"

Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = "fog"
  s.version           = "2.2.0"
  s.date              = "2019-06-18"
  s.rubyforge_project = "fog"

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "brings clouds to you"
  s.description = "The Ruby cloud services library. Supports all major cloud providers including AWS, Rackspace, Linode, Blue Box, StormOnDemand, and many others. Full support for most AWS services including EC2, S3, CloudWatch, SimpleDB, ELB, and RDS."

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["geemus (Wesley Beary)"]
  s.email    = "geemus@gmail.com"
  s.homepage = "https://github.com/fog/fog"
  s.license  = "MIT"

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

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency("fog-core", "~> 2.1")
  s.add_dependency("fog-json")
  s.add_dependency("fog-xml", "~> 0.1.1")

  s.add_dependency("json", "~> 2.0")
  s.add_dependency("ipaddress", "~> 0.5")

  # Modular providers (please keep sorted)
  s.add_dependency("fog-aliyun",">= 0.1.0")
  s.add_dependency("fog-atmos")
  s.add_dependency("fog-aws", ">= 0.6.0")
  s.add_dependency("fog-brightbox", "~> 0.4")
  s.add_dependency("fog-cloudatcost", "~> 0.4")
  s.add_dependency("fog-cloudstack", "~> 0.1.0")
  s.add_dependency("fog-digitalocean", ">= 0.3.0")
  s.add_dependency("fog-dnsimple", "~> 2.1")
  s.add_dependency("fog-dynect", "~> 0.0.2")
  s.add_dependency("fog-ecloud", "~> 0.1")
  s.add_dependency("fog-google", "~> 1.0")
  s.add_dependency("fog-internet-archive")
  s.add_dependency("fog-local")
  s.add_dependency("fog-openstack")
  s.add_dependency("fog-ovirt")
  s.add_dependency("fog-powerdns", ">= 0.1.1")
  s.add_dependency("fog-profitbricks")
  s.add_dependency("fog-rackspace")
  s.add_dependency("fog-radosgw", ">= 0.0.2")
  s.add_dependency("fog-riakcs")
  s.add_dependency("fog-sakuracloud", ">= 0.0.4")
  s.add_dependency("fog-serverlove")
  s.add_dependency("fog-softlayer")
  s.add_dependency("fog-storm_on_demand")
  s.add_dependency("fog-terremark")
  s.add_dependency("fog-vmfusion")
  s.add_dependency("fog-voxel")
  s.add_dependency("fog-vsphere", ">= 0.4.0")
  s.add_dependency("fog-xenserver")

  s.add_development_dependency("docker-api", ">= 1.13.6")
  s.add_development_dependency("fission")
  s.add_development_dependency("mime-types")
  s.add_development_dependency("minitest")
  s.add_development_dependency("minitest-stub-const")
  s.add_development_dependency("opennebula")
  s.add_development_dependency("pry")
  s.add_development_dependency("rake")
  s.add_development_dependency("rbvmomi")
  s.add_development_dependency("rubocop", "0.52.1")
  s.add_development_dependency("shindo", "~> 0.3.4")
  s.add_development_dependency("simplecov")
  s.add_development_dependency("thor")
  s.add_development_dependency("yard")
  s.add_development_dependency("rspec-core")
  s.add_development_dependency("rspec-expectations")
  s.add_development_dependency("vcr")
  s.add_development_dependency("webmock","~>1.22.2")

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec,tests}/*`.split("\n")

  postinstall_message =  <<-POSTINST
------------------------------
Thank you for installing fog!

IMPORTANT NOTICE:
If there's a metagem available for your cloud provider, e.g. `fog-aws`,
you should be using it instead of requiring the full fog collection to avoid
unnecessary dependencies.

'fog' should be required explicitly only if the provider you use doesn't yet
have a metagem available.
------------------------------
  POSTINST

  s.post_install_message = postinstall_message
end
