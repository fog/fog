#!/usr/bin/env gem build
# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'base64'
require 'date'
require 'fog/core/version'

::Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = ::Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.7'
  s.platform = ::Gem::Platform::RUBY

  ## Leave these as is they will be modified for you by the rake gemspec task.
  ## If your rubyforge_project name is different, then edit it and comment out
  ## the sub! line in the Rakefile
  s.name              = 'fog'
  s.version           = ::Fog::Version::STRING
  s.date              = ::Date.today.to_s
  s.rubyforge_project = 'fog'

  ## Make sure your summary is short. The description may be as long
  ## as you like.
  s.summary     = "brings clouds to you"
  s.description = "The Ruby cloud computing library."

  ## List the primary authors. If there are a bunch of authors, it's probably
  ## better to set the email to an email list or something. If you don't have
  ## a custom homepage, consider using your GitHub URL or the like.
  s.authors  = ["geemus (Wesley Beary)"]
  s.email    = ::Base64.decode64("Z2VlbXVzQGdtYWlsLmNvbQ==\n")
  s.homepage = 'http://github.com/geemus/fog'

  ## This gets added to the $LOAD_PATH so that 'lib/NAME.rb' can be required as
  ## require 'NAME.rb' or'/lib/NAME/file.rb' can be as require 'NAME/file.rb'
  s.require_paths = %w[lib, ext]

  ## If your gem includes any executables, list them here.
  s.executables = ["fog"]
  s.default_executable = 'fog'
  s.extensions << 'ext/geminstall_hook/extconf.rb'

  ## Specify any RDoc options here. You'll want to add your README and
  ## LICENSE files to the extra_rdoc_files list.
  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.rdoc]

  s.files = ::Dir.glob("{examples,bin,lib,tasks}/**/*.{rb,rake}")
  s.files += %w[bin/fog
    Rakefile
    Gemfile
    Gemfile.lock
    README.rdoc
    Rakefile
    PostInstall.txt
    fog.gemspec]
  s.add_dependency('bundler', '~>1.0.4')

  s.post_install_message = ::File.open(File.join(File.dirname(__FILE__), "PostInstall.txt")).read rescue ""

end
