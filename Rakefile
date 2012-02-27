require 'rubygems'
require 'bundler/setup'
require 'date'
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
  Rake::Task[:mock_tests].invoke && Rake::Task[:real_tests].invoke
end

def tests(mocked)
  Formatador.display_line
  sh("export FOG_MOCK=#{mocked} && bundle exec spec spec")
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

require 'rdoc/task'
RDoc::Task.new do |rdoc|
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

task :changelog do
  timestamp = Time.now.utc.strftime('%m/%d/%Y')
  sha = `git log | head -1`.split(' ').last
  changelog = ["#{version} #{timestamp} #{sha}"]
  changelog << ('=' * changelog[0].length)
  changelog << ''

  require 'multi_json'
  github_repo_data = MultiJson.decode(Excon.get('http://github.com/api/v2/json/repos/show/fog/fog').body)
  data = github_repo_data['repository'].reject {|key, value| !['forks', 'open_issues', 'watchers'].include?(key)}
  github_collaborator_data = MultiJson.decode(Excon.get('http://github.com/api/v2/json/repos/show/fog/fog/collaborators').body)
  data['collaborators'] = github_collaborator_data['collaborators'].length
  rubygems_data = MultiJson.decode(Excon.get('https://rubygems.org/api/v1/gems/fog.json').body)
  data['downloads'] = rubygems_data['downloads']
  stats = []
  for key in data.keys.sort
    stats << "'#{key}' => #{data[key]}"
  end
  changelog << "Stats! { #{stats.join(', ')} }"
  changelog << ''

  last_sha = `cat changelog.txt | head -1`.split(' ').last
  shortlog = `git shortlog #{last_sha}..HEAD`
  changes = {}
  committers = {}
  for line in shortlog.split("\n")
    if line =~ /^\S/
      committer = line.split(' (', 2).first
      committers[committer] = 0
    elsif line =~ /^\s*((Merge.*)|(Release.*))?$/
      # skip empty lines, Merge and Release commits
    else
      unless line[-1..-1] == '.'
        line << '.'
      end
      line.lstrip!
      line.gsub!(/^\[([^\]]*)\] /, '')
      tag = $1 || 'misc'
      changes[tag] ||= []
      changes[tag] << (line << ' thanks ' << committer)
      committers[committer] += 1
    end
  end

  for committer, commits in committers.to_a.sort {|x,y| y[1] <=> x[1]}
    if [
        'Aaron Suggs',
        'Brian Hartsock',
        'Christopher Oliver',
        'Dylan Egan',
        'geemus',
        'Henry Addison',
        'Lincoln Stoll',
        'Luqman Amjad',
        'Michael Zeng',
        'nightshade427',
        'Patrick Debois',
        'Stepan G. Fedorov',
        'Wesley Beary'
      ].include?(committer)
      next
    end
    changelog << "MVP! #{committer}"
    changelog << ''
    break
  end

  for tag in changes.keys.sort
    changelog << ('[' << tag << ']')
    for commit in changes[tag]
      changelog << ('  ' << commit)
    end
    changelog << ''
  end

  old_changelog = File.read('changelog.txt')
  File.open('changelog.txt', 'w') do |file|
    file.write(changelog.join("\n"))
    file.write("\n\n")
    file.write(old_changelog)
  end
end

task :docs do
  Rake::Task[:supported_services_docs].invoke
  Rake::Task[:upload_fog_io].invoke
  Rake::Task[:upload_rdoc].invoke

  # connect to storage provider
  Fog.credential = :geemus
  storage = Fog::Storage.new(:provider => 'AWS')
  directory = storage.directories.new(:key => 'fog.io')
  # write base index with redirect to new version
  directory.files.create(
    :body         => redirecter('latest'),
    :content_type => 'text/html',
    :key          => 'index.html',
    :public       => true
  )

  Formatador.display_line
end

task :supported_services_docs do
  support, shared = {}, []
  for key, values in Fog.services
    unless values.length == 1
      shared |= [key]
      values.each do |value|
        support[value] ||= {}
        support[value][key] = '+'
      end
    else
      value = values.first
      support[value] ||= {}
      support[value][:other] ||= []
      support[value][:other] << key
    end
  end
  shared.sort! {|x,y| x.to_s <=> y.to_s}
  columns = [:provider] + shared + [:other]
  data = []
  for key in support.keys.sort {|x,y| x.to_s <=> y.to_s}
    data << { :provider => key }.merge!(support[key])
  end

  table = ''
  table << "<table border='1'>\n"

  table << "  <tr>"
  for column in columns
    table << "<th>#{column}</th>"
  end
  table << "</tr>\n"

  for datum in data
    table << "  <tr>"
    for column in columns
      if value = datum[column]
        case value
        when Array
          table << "<td>#{value.join(', ')}</td>"
        when '+'
          table << "<td style='text-align: center;'>#{value}</td>"
        else
          table << "<th>#{value}</th>"
        end
      else
        table << "<td></td>"
      end
    end
    table << "</tr>\n"
  end

  table << "</table>\n"

  File.open('docs/about/supported_services.markdown', 'w') do |file|
    file.puts <<-METADATA
---
layout: default
title:  Supported Services
---

METADATA
    file.puts(table)
  end
end

task :upload_fog_io do
  # connect to storage provider
  Fog.credential = :geemus
  storage = Fog::Storage.new(:provider => 'AWS')
  directory = storage.directories.new(:key => 'fog.io')

  # build the docs locally
  sh "jekyll docs docs/_site"

  # write web page files to versioned 'folder'
  for file_path in Dir.glob('docs/_site/**/*')
    next if File.directory?(file_path)
    file_name = file_path.gsub('docs/_site/', '')
    key = '' << version << '/' << file_name
    Formatador.redisplay(' ' * 128)
    Formatador.redisplay("Uploading [bold]#{key}[/]")
    if File.extname(file_name) == '.html'
      # rewrite links with version
      body = File.read(file_path)
      body.gsub!(/vX.Y.Z/, 'v' << version)
      body.gsub!(/='\//, %{='/} << version << '/')
      body.gsub!(/="\//, %{="/} << version << '/')
      content_type = 'text/html'
      directory.files.create(
        :body         => redirecter(key),
        :content_type => 'text/html',
        :key          => 'latest/' << file_name,
        :public       => true
      )
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
  Formatador.redisplay(' ' * 128)
  Formatador.redisplay("Uploaded docs/_site\n")
end

task :upload_rdoc do
  # connect to storage provider
  Fog.credential = :geemus
  storage = Fog::Storage.new(:provider => 'AWS')
  directory = storage.directories.new(:key => 'fog.io')

  # write rdoc files to versioned 'folder'
  Rake::Task[:rdoc].invoke
  for file_path in Dir.glob('rdoc/**/*')
    next if File.directory?(file_path)
    file_name = file_path.gsub('rdoc/', '')
    key = '' << version << '/rdoc/' << file_name
    Formatador.redisplay(' ' * 128)
    Formatador.redisplay("Uploading [bold]#{key}[/]")
    directory.files.create(
      :body         => File.open(file_path),
      :key          => key,
      :public       => true
    )
  end
  Formatador.redisplay(' ' * 128)
  directory.files.create(
    :body         => redirecter("#{version}/rdoc/index.html"),
    :content_type => 'text/html',
    :key          => 'latest/rdoc/index.html',
    :public       => true
  )
  Formatador.redisplay("Uploaded rdoc\n")
end

def redirecter(path)
  redirecter = <<-HTML
<!doctype html>
<head>
<title>fog</title>
<meta http-equiv="REFRESH" content="0;url=http://fog.io/#{path}">
</head>
<body>
  <a href="http://fog.io/#{path}">redirecting to lastest (#{path})</a>
</body>
</html>
HTML
end
