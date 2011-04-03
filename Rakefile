require 'rubygems'
require 'bundler/setup'
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

task :examples do
  sh("export FOG_MOCK=false && bundle exec shindont examples")
  # some don't provide mocks so we'll leave this out for now
  # sh("export FOG_MOCK=true  && bundle exec shindont examples")
end

task :test => :examples do
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
  sh "gem install pkg/#{name}-#{version}.gem"
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

task :docs do
  # build the docs locally
  sh "jekyll docs docs/_site"

  # connect to storage provider and write files to versioned 'folder'
  Fog.credential = :geemus
  storage = Fog::Storage.new(:provider => 'AWS')
  directory = storage.directories.new(:key => 'fog.io')
  for file_path in Dir.glob('docs/_site/**/*')
    next if File.directory?(file_path)
    file_name = file_path.gsub('docs/_site/', '')
    key = '' << version << '/' << file_name
    Formatador.redisplay(' ' * 80) # clear last line
    Formatador.redisplay('Uploading ' << key)
    if File.extname(file_name) == '.html'
      # rewrite links with version
      body = File.read(file_path)
      body.gsub!(/href="\//, 'href="/' << version << '/')
      content_type = 'text/html'
    else
      body = File.open(file_path)
      content_type = nil # leave it up to mime-types
    end
    directory.files.create(
      :body         => body,
      :content_type => content_type,
      :key          => key,
      :public       => true
    )
  end

  # write base index with redirect to new version
  directory.files.create(
    :body         => '<!doctype html><head><script>window.location = "http://fog.io/' << version << '/index.html"</script></head></html>',
    :content_type => 'text/html',
    :key          => 'index.html',
    :public       => true
  )

  Formatador.display_line
end
