require 'rubygems'
require 'rake'

current_directory = File.dirname(__FILE__)
require "#{current_directory}/lib/fog"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.add_dependency('mime-types')
    gem.add_dependency('nokogiri')
    gem.add_dependency('ruby-hmac')
    gem.name = "fog"
    gem.description = %Q{brings clouds to you}
    gem.summary = %Q{fog = clouds + you}
    gem.email = "me@geemus.com"
    gem.homepage = "http://github.com/geemus/fog"
    gem.authors = ["Wesley Beary"]
    gem.rubyforge_project = "fog"
  
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
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
    Fog.mocking = true
    Rake::Task[:spec].invoke
  end

  task :without_mocking do
    Fog.mocking = true
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
