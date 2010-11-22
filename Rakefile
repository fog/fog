require 'rubygems'
unless ENV['NOBUNDLE']
  begin
    require 'bundler/setup' unless defined?(Bundler)
  rescue LoadError
    $stderr.puts "Run `gem install bundler` and `bundle install` to install missing gems"
    $stderr.puts caller.join("\n")
    exit e.status_code
  end
end

begin
  Bundler.require(:common, :rake)
rescue LoadError
  $stderr.puts "Run `bundle install` to install gems missing from common or rake groups"
  $stderr.puts caller.join("\n")
  exit e.status_code
end

$LOAD_PATH.unshift('lib')

require 'rake'
require 'date'
require 'fog'

Dir.glob("tasks/*.rake").each do |f|
  Rake.application.rake_require "./../tasks/#{File.basename(f, '.rake')}"
end

# Work around an issue introduced between Bundler 1.0.3 and 1.0.7
module Bundler
  class GemHelper
    def self.install_tasks(opts = nil)
      dir = Rake.application.find_rakefile_location[1]
      self.new(dir, opts && opts[:name]).install
    end
  end
end

Bundler::GemHelper.install_tasks(:name => 'fog' )

#############################################################################
#
# Helper functions
#
#############################################################################

# Kudos Ken Collins, Eugene Bolshakov, John Wood, and Mark Foster
# - we want to redirect Bundler's release task (this works in namespaces too).
# - See http://www.metaskills.net/2010/5/26/the-alias_method_chain-of-rake-override-rake-task
Rake::TaskManager.class_eval do
  def alias_task(fq_name)
    new_name = "#{fq_name}:original"
    @tasks[new_name] = @tasks.delete(fq_name)
  end
end

def alias_task(fq_name)
  Rake.application.alias_task(fq_name)
end

def override_task(*args, &block)
  name, params, deps = Rake.application.resolve_args(args.dup)
  fq_name = Rake.application.instance_variable_get(:@scope).dup.push(name).join(':')
  alias_task(fq_name)
  rt = Rake.application.tasks.select {|t| t.name =~ /release/ }
  cmt = "You must use a type of release task. Example - increment build number: rake release:build"
  rt[0].instance_variable_set(:@comment, cmt)
  Rake::Task.define_task(*args, &block)
end

override_task :release do
  msg = "You must use a type of release task. Example - increment build number: rake release:build"
  raise Exception.new(msg)
  # To invoke the original Bundler task add ":original" i.e rake release:original
end

@rakefile_dir = Rake.application.find_rakefile_location[1]
@version_helper = ::Fog::VersionHelper.new(File.join(@rakefile_dir,'lib','fog','core'))

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def preview_version(vt)
  @version_helper.preview_version(vt)
end

def version
  ::Fog::VERSION
end

def preview_tag(vt)
  "v#{preview_version(vt)}"
end

def version_tag
  "v#{version}"
end

def version_dir
  File.expand_path("lib/fog/core/")
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

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= ').*'/) { "#{$1}#{send(header_name)}'"}
end

#############################################################################
#
# Standard tasks
#
#############################################################################

task :default => :test

task :test do
  sh("export FOG_MOCK=true  && bundle exec spec -cfs spec") &&
  sh("export FOG_MOCK=true  && bundle exec shindo tests") &&
  sh("export FOG_MOCK=false && bundle exec spec -cfs spec") &&
  sh("export FOG_MOCK=false && bundle exec shindo tests")
end

task :ci do
  sh("export FOG_MOCK=true  && bundle exec spec spec") &&
  sh("export FOG_MOCK=true  && bundle exec shindont tests") &&
  sh("export FOG_MOCK=false && bundle exec spec spec") &&
  sh("export FOG_MOCK=false && bundle exec shindont tests")
end

desc "Generate RCov test coverage and open in your browser"
task :coverage do
  require 'rcov'
  sh "rm -fr coverage"
  sh "rcov test/test_*.rb"
  sh "open coverage/index.html"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "#{name} #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/#{name}.rb"
end

#############################################################################
#
# Release tasks
#
#############################################################################

namespace 'release' do
  desc "Create tag #{preview_tag(:major)} and build and push #{name}-#{preview_version(:major)}.gem to Rubygems"
  task :major do
    ver = ::Fog::VersionHelper.new(version_dir)
    ver.bump_major
    Rake::Task["release:original"].execute # Run Bundler's release task
  end

  desc "Create tag #{preview_tag(:minor)} and build and push #{name}-#{preview_version(:minor)}.gem to Rubygems"
  task :minor do
    ver = ::Fog::VersionHelper.new(version_dir)
    ver.bump_minor
    Rake::Task["release:original"].execute # Run Bundler's release task
  end

  desc "Create tag #{preview_tag(:patch)} and build and push #{name}-#{preview_version(:patch)}.gem to Rubygems"
  task :patch do
    ver = ::Fog::VersionHelper.new(version_dir)
    ver.bump_patch
    Rake::Task["release:original"].execute # Run Bundler's release task
  end

  desc "Create tag #{preview_tag(:build)} and build and push #{name}-#{preview_version(:build)}.gem to Rubygems"
  task :build do
    ver = ::Fog::VersionHelper.new(version_dir)
    ver.bump_build
    Rake::Task["release:original"].execute # Run Bundler's release task
  end

  desc "Writes out an explicit version. Respects (default is 0) the environment variables: MAJOR, MINOR, PATCH, BUILD."
  task :custom, :major, :minor, :patch, :build do |t, args|
    args.with_defaults(:major => ENV['MAJOR'].to_i, :minor => ENV['MINOR'].to_i, :patch => ENV['PATCH'].to_i, :build => ENV['BUILD'].to_i)
    ver = ::Fog::VersionHelper.new(version_dir)
    ver.bump_custom(args)
    Rake::Task["release:original"].execute # Run Bundler's release task
    $stdout.puts "Updated version: #{ver.to_s}"
  end

end
