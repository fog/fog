require 'rubygems'
require 'rake'

current_directory = File.dirname(__FILE__)
require "#{current_directory}/lib/fog"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.add_dependency('excon', '>=0.0.18')
    gem.add_dependency('mime-types')
    gem.add_dependency('nokogiri')
    gem.add_dependency('ruby-hmac')
    gem.name = "fog"
    gem.description = %Q{brings clouds to you}
    gem.summary = %Q{fog = clouds + you}
    gem.email = "me@geemus.com"
    gem.homepage = "http://github.com/geemus/fog"
    gem.authors = ["geemus (Wesley Beary)"]
    gem.rubyforge_project = "fog"

    gem.post_install_message = <<MESSAGE
#{'=' * 50}

  fog 0.0.41 has a minor change to the API for ec2 servers:

    # what_it_was => what_it_is

    ec2.servers.new(:group_id => 'foo') => ec2.servers.new(:groups => ['foo'])

  Updating to the newest api version also means you can now assign multiple groups:

    ec2.servers.new(:groups => ['foo', 'bar'])

#{'=' * 50}

  fog 0.0.40 has API changes you should know about.

  Some changes you might care about happened in the models:

    # what_it_was => what_it_is

    ec2.instances => ec2.servers
    ec2.instance  => ec2.server

    s3.buckets  => s3.directories
    s3.bucket   => s3.directory

    s3.objects  => s3.files
    s3.object   => s3.file

  Sorry for the bother, but it will allow for a more consistent API as fog continues to expand.

#{'=' * 50}
MESSAGE

  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_opts = ['-c']
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

namespace :specs do

  task :with_mocking do
    Fog.mock!
    Rake::Task[:spec].invoke
  end

  task :without_mocking do
    Fog.mock!
    Rake::Task[:spec].invoke
  end

end

desc 'Run specs with and without mocking'
task :specs => %w[ specs:with_mocking specs:without_mocking ]

task :default => :specs

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fog #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do
    
    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]
    
    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/fog/"
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end
