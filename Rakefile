require 'bundler/setup'
require 'date'
require 'rubygems'
require 'rubygems/package_task'
require 'yard'
require File.dirname(__FILE__) + '/lib/fog'

#############################################################################
#
# Helper functions
#
#############################################################################

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  line = File.read("lib/#{name}.rb")[/^\s*VERSION\s*=\s*.*/]
  line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
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

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= ').*'/) { "#{$1}#{send(header_name)}'"}
end

#############################################################################
#
# Standard tasks
#
#############################################################################

GEM_NAME = "#{name}"
task :default => :test

namespace :test do
  task :dynect do
    [false].each do |mock|
      sh("export FOG_MOCK=#{mock} && bundle exec shindont tests/dns/requests/dynect")
      #sh("export FOG_MOCK=#{mock} && bundle exec shindont tests/dns/models/")
    end
  end
end

task :test do
  Rake::Task[:mock_tests].invoke
end

def tests(mocked)
  Formatador.display_line
  start = Time.now.to_i
  threads = []
  Thread.main[:results] = []
  Fog.providers.each do |key, value|
    threads << Thread.new do
      Thread.main[:results] << {
        :provider => value,
        :success  => sh("export FOG_MOCK=#{mocked} && bundle exec shindont +#{key}")
      }
    end
  end
  threads.each do |thread|
    thread.join
  end
  Formatador.display_table(Thread.main[:results].sort {|x,y| x[:provider] <=> y[:provider]})
  Formatador.display_line("[bold]FOG_MOCK=#{mocked}[/] tests completed in [bold]#{Time.now.to_i - start}[/] seconds")
  Formatador.display_line
end

task :mock_tests do
  tests(true)
end

task :real_tests do
  tests(false)
end

task :nuke do
  Fog.providers.each do |provider|
    next if ['Vmfusion'].include?(provider)
    begin
      compute = Fog::Compute.new(:provider => provider)
      for server in compute.servers
        Formatador.display_line("[#{provider}] destroying server #{server.identity}")
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
        Formatador.display_line("[#{provider}] destroying zone #{zone.identity}")
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

task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  sh "gem install pkg/#{name}-#{version}.gem"
  sh "git commit --allow-empty -a -m 'Release #{version}'"
  sh "git tag v#{version}"
  sh "git push origin master"
  sh "git push origin v#{version}"
  sh "gem push pkg/#{name}-#{version}.gem"
  Rake::Task[:docs].invoke
end

task :build => :gemspec do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end

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

task :validate do
  libfiles = Dir['lib/*'] - ["lib/#{name}.rb", "lib/#{name}"]
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

require "fog/rake/changelog_task"
Fog::Rake::ChangelogTask.new

require "fog/rake/documentation_task"
Fog::Rake::DocumentationTask.new

