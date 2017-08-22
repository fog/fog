require 'bundler/setup'
require 'rake/testtask'
require 'date'
require 'rubygems'
require 'rubygems/package_task'
require 'yard'
require File.dirname(__FILE__) + '/lib/fog'

require "tasks/changelog_task"
Fog::Rake::ChangelogTask.new

require "tasks/github_release_task"
Fog::Rake::GithubReleaseTask.new

#############################################################################
#
# Helper functions
#
#############################################################################

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  Fog::VERSION
end

def date
  Date.today.to_s
end

def rubyforge_project
  name
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

def package_gem_file
  "pkg/#{gem_file}"
end

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= \").*\"/) { "#{$1}#{send(header_name)}\""}
end

#############################################################################
#
# Standard tasks
#
#############################################################################

GEM_NAME = "#{name}"
task :default => :test
task :travis  => ['test', 'test:travis']

Rake::TestTask.new do |t|
  t.pattern = File.join("spec", "**", "*_spec.rb")
  t.libs << "spec"
end

namespace :test do
  mock = ENV['FOG_MOCK'] || 'true'
  task :travis do
      sh("export FOG_MOCK=#{mock} && bundle exec shindont")
  end
  task :openvz do
      sh("export FOG_MOCK=#{mock} && bundle exec shindont tests/openvz")
  end
  task :cloudstack do
      sh("export FOG_MOCK=#{mock} && bundle exec shindont tests/cloudstack")
  end
  task :vcloud_director do
      sh("export FOG_MOCK=#{mock} && bundle exec shindont tests/vcloud_director")
  end
  task :vcloud_director_specs do
    puts "Running vCloud Minitest Suite"
    Rake::TestTask.new do |t|
      Dir.glob('./spec/vcloud_director/**/*_spec.rb').each { |file| require file}
    end
  end
end

desc 'Run mocked tests for a specific provider'
task :mock, :provider do |t, args|
  if args.to_a.size != 1
    fail 'USAGE: rake mock[<provider>]'
  end
  provider = args[:provider]
  sh("export FOG_MOCK=true && bundle exec shindont tests/#{provider}")
end

desc 'Run live tests against a specific provider'
task :live, :provider do |t, args|
  if args.to_a.size != 1
    fail 'USAGE: rake live[<provider>]'
  end
  provider = args[:provider]
  sh("export FOG_MOCK=false PROVIDER=#{provider} && bundle exec shindont tests/#{provider}")
end

task :nuke do
  Fog.providers.each do |provider|
    next if ['Vmfusion'].include?(provider)
    begin
      compute = Fog::Compute.new(:provider => provider)
      for server in compute.servers
        Fog::Formatador.display_line("[#{provider}] destroying server #{server.identity}")
        server.destroy rescue nil
      end
    rescue
    end
    begin
      dns = Fog::DNS.new(:provider => provider)
      for zone in dns.zones
        for record in zone.records
          record.destroy rescue nil
        end
        Fog::Formatador.display_line("[#{provider}] destroying zone #{zone.identity}")
        zone.destroy rescue nil
      end
    rescue
    end
  end
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/#{name}.rb"
end

#############################################################################
#
# Packaging tasks
#
#############################################################################

task :release => ["release:prepare", "release:publish"]

namespace :release do
  task :preflight do
    unless `git branch` =~ /^\* master$/
      puts "You must be on the master branch to release!"
      exit!
    end
    if `git tag` =~ /^\* v#{version}$/
      puts "Tag v#{version} already exists!"
      exit!
    end
  end

  task :prepare => :preflight do
    Rake::Task[:build].invoke
    sh "gem install #{package_gem_file}"
    Rake::Task[:git_mark_release].invoke
  end

  task :publish do
    Rake::Task[:git_push_release].invoke
    Rake::Task[:gem_push].invoke
  end
end

task :git_mark_release do
  sh "git commit --allow-empty -a -m 'Release #{version}'"
end

task :git_push_release do
  sh "git push origin master"
  ::Rake::Task[:github_release].invoke
end

task :gem_push do
  sh "gem push #{package_gem_file}"
end

desc "Build fog-#{version}.gem"
task :build => :gemspec do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end
task :gem => :build

desc "Install fog-#{version}.gem"
task "install" do
  Rake::Task[:build].invoke
  sh "gem install #{package_gem_file} --no-document"
end

desc "Updates the gemspec and runs 'validate'"
task :gemspec => :validate do
  # read spec file and split out manifest section
  spec = File.read(gemspec_file)

  # replace name version and date
  replace_header(spec, :name)
  replace_header(spec, :version)
  replace_header(spec, :date)
  #comment this out if your rubyforge_project has a different name
  replace_header(spec, :rubyforge_project)

  File.open(gemspec_file, 'w') { |io| io.write(spec) }
  puts "Updated #{gemspec_file}"
end

desc "Run before pushing out the code"
task :validate do
  libfiles = Dir['lib/*'] - ["lib/#{name}.rb", "lib/#{name}", "lib/tasks"]
  unless libfiles.empty?
    puts "Directory `lib` should only contain a `#{name}.rb` file and `#{name}` dir."
    exit!
  end
  unless Dir['VERSION*'].empty?
    puts "A `VERSION` file at root level violates Gem best practices."
    exit!
  end
end

# Include Yard tasks for rake yard
YARDOC_LOCATION = "doc"
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb', "README"]
  t.options = ["--output-dir", YARDOC_LOCATION, "--title", "#{name} #{version}"]
end
