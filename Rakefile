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
# Packaging tasks
#
#############################################################################

task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  sh "sudo gem install pkg/#{name}-#{version}.gem"
  sh "git commit --allow-empty -a -m 'Release #{version}'"
  sh "git tag v#{version}"
  sh "git push origin master"
  sh "git push origin v#{version}"
  sh "gem push pkg/#{name}-#{version}.gem"
end

task :build do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
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
