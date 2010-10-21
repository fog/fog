require 'rubygems'
require 'bundler/setup'
require 'date'

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

def bdd_state(state)
  state.to_s=='mocked' ? true : false
end

def exec_vendor_specs(vendor='aws', state='mocked')
  begin
    puts "Spec run:  #{state} #{bdd_state(state)}"
    if Dir.exists?("spec/#{vendor}")
      sh("export FOG_MOCK=#{bdd_state(state)} && bundle exec spec -cfs spec/#{vendor}")
    end
  rescue Exception => e
    puts e.message
    puts e.backtrace.inspect
  ensure
    puts "Continuing..."
  end
end
def exec_vendor_tests(vendor='aws', state='mocked')
  begin
    puts "Tests run:  #{state} #{bdd_state(state)}"
    if Dir.exists?("tests/#{vendor}")
      sh("export FOG_MOCK=#{bdd_state(state)} && bundle exec shindo tests/#{vendor}")
    end
  rescue Exception => e
    puts e.message
    puts e.backtrace.inspect
  ensure
    puts "Continuing..."
  end  
end
def exec_vendor_spec_async(vendor='aws', state='mocked', file='spec/aws')
  puts "Async spec run:  #{state} #{bdd_state(state)}"
  sh("export FOG_MOCK=#{bdd_state(state)} && bundle exec spec -cfs #{file} &")
end
def exec_vendor_test_async(vendor='aws', state='mocked', file='tests/aws')
  sh("export FOG_MOCK=#{bdd_state(state)} && bundle exec shindo #{file} &")
end
def exec_vendor(name, state)
  exec_vendor_specs(name, state)
  exec_vendor_tests(name, state)
end
def exec_spec_files(fs, state, vnd)
  fs.each do |f|
    exec_vendor_spec_async(vnd, state, f)
  end
end
def exec_test_files(fs, state, vnd)
  fs.each do |f|
    exec_vendor_test_async(vnd, state, f)
  end
end
def exec_vendor_async(vnd, state)
  root=File.expand_path('.')
  spec_files=Dir.glob("#{root}/spec/#{vnd}/**/*_spec.rb")
  test_files=Dir.glob("#{root}/tests/#{vnd}/**/*_tests.rb")
  exec_spec_files(spec_files, state, vnd) if spec_files.length > 0
  exec_test_files(test_files, state, vnd) if test_files.length > 0
end

def clouds_lists
  dl={:tests => [], :spec => []};
  Dir["./{spec,tests}/*"].each do |d|
    if File.directory?(d)
      unless ( d =~ /help|example/ )
        if ( d =~ /\.\/tests\// )
          dl[:tests] << d.sub(/\.\/tests\//,'')
        elsif
          dl[:spec] << d.sub(/\.\/spec\//,'')
        end        
      end
    end
  end
  dl
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


namespace :spec do

  namespace :clouds do

#    desc "Run Fog's RSpec for all cloud vendors and both states, live and mocked."
#    task :all => ['aws:all']

    desc "List all cloud vendors and whether they have live and mock tests and spec's"
    task :list do
      tbl=[]
      tbl<< 'Vendor         BDD State'
      tbl<< '======         ========='
      cls=clouds_lists
      cl=cls[:tests]|cls[:spec]
      cl.sort.each do |v|
        tbl << "#{v.to_s}".ljust(14, '.') + "live  ".rjust(12, '.')
        tbl << "#{v.to_s}".ljust(14, '.') + "mocked".rjust(10, '.')
      end
      puts tbl
    end

  end

  namespace :async do

    desc 'Async run Fog\'s RSpec for vendor (default :aws) and state (default :mocked)'
    task :cloud, [:vendor, :state] => [:pre_vendor, :pre_state] do |t, args|
      args.with_defaults(:vendor => :aws, :state => :mocked)
      exec_vendor_async(args.vendor, args.state)
    end

    desc 'Async run Fog\'s RSpec for all vendors with state (default :mocked)'
    task :all, [:state] do |t, args|
      args.with_defaults(:state => :mocked)
      cls=clouds_lists
      cl=cls[:tests]|cls[:spec]
      cl.sort.each do |v|
        exec_vendor_async(v, args.state)
      end
    end

  end

  desc "Run Fog's RSpec for vendor (default :aws) and state (default :mocked)"
  task :cloud, [:vendor, :state] => [:pre_vendor, :pre_state] do |t, args|
    args.with_defaults(:vendor => :aws, :state => :mocked)
    exec_vendor(args.vendor, args.state)
  end

  #  Prepare to run Fog's RSpec for vendor (default :aws) and state (default :mocked)"
  task :pre_vendor do |t|
    # puts "Vendor preparation task"
  end
  task :pre_state do |t|
    # puts "State preparation task"
  end

  desc 'Run Fog\'s RSpec for all vendors with state (default :mocked)'
  task :all, [:state] do |t, args|
    args.with_defaults(:state => :mocked)
    cls=clouds_lists
    cl=cls[:tests]|cls[:spec]
    cl.sort.each do |v|
      puts "Vendor: #{v} State: #{args.state}"
      exec_vendor(v, args.state)
    end
  end

end


desc "Run AWS Fog specs and tests live or mocked"
task :aws, [:state] do |t, args|
  args.with_defaults(:state => :mocked)
  exec_vendor(t.name, args.state)
end

namespace :async do

  desc "Async run AWS Fog specs and tests live or mocked"
  task :aws, [:state] do |t, args|
    args.with_defaults(:state => :mocked)
    vnd=tsk.name.split(':').last
    exec_vendor_async(vnd, args.state)
  end

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

task :build => :gemspec do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg"
end

task :gemspec => :validate do
  # read spec file and split out manifest section
  spec = File.read(gemspec_file)
  head, manifest, tail = spec.split("  # = MANIFEST =\n")

  # replace name version and date
  replace_header(head, :name)
  replace_header(head, :version)
  replace_header(head, :date)
  #comment this out if your rubyforge_project has a different name
  replace_header(head, :rubyforge_project)

  # determine file list from git ls-files
  files = `git ls-files`.
    split("\n").
    sort.
    reject { |file| file =~ /^\./ }.
    reject { |file| file =~ /^(rdoc|pkg)/ }.
    map { |file| "    #{file}" }.
    join("\n")

  # piece file back together and write
  manifest = "  s.files = %w[\n#{files}\n  ]\n"
  spec = [head, manifest, tail].join("  # = MANIFEST =\n")
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
