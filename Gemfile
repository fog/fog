source :rubygems

#
# Common, i.e. across production, testing and benchmark groups.
#
group :common do
  gem 'rake', '0.8.7'
  gem 'builder', '2.1.2'
  gem 'excon', '>= 0.2.4'
  gem 'formatador', '>= 0.0.15'
  gem 'json', '1.4.6'
  gem 'mime-types', '1.16'
  gem 'net-ssh', '~>2.0.23'
  gem 'ruby-hmac', '0.4.0'
  gem 'nokogiri', '~> 1.4.3.1'
  gem 'yard', '0.6.2'
end

group :production do
end

group :rake do
  gem 'rake', '0.8.7'
  gem 'i18n', '>=0.4.2'
  #gem 'hydra', '0.23.1'
  #gem "test-unit"
end

#
# bdd collects gems required by Rspec, Shindo, Cucumber and ...
#
group :bdd do
  gem 'rake', '0.8.7'
  gem 'fakefs', '0.2.1', :require => 'fakefs/safe'
  gem 'fakefs-require', '0.2.1', :require => 'fakefs/require'
end

group :cukes do
  gem 'cucumber', '0.9.3'
  gem 'aruba', '0.2.4'    # Load order matters
  gem 'guard-cucumber', '0.2.0' unless Config::CONFIG['target_os'] =~ /mswin/i
end

group :rspec do
  gem 'rspec', '~>2.1.0', :require => 'rspec'
  gem 'guard-rspec', '0.1.7' unless Config::CONFIG['target_os'] =~ /mswin/i
  gem 'configuration', '1.1.0' unless Config::CONFIG['target_os'] =~ /mswin/i
end

group :shindo do
  gem 'shindo', '0.1.7'
  gem 'gestalt', '>= 0.0.11'
end

group :metrics do
  gem 'metric_fu', '2.0.1' #, :path => '/usr/src/metric_fu'
  gem 'flay', '1.4.1'
  gem 'flog', '2.5.0'
  gem 'progressbar', '0.9.0'
  gem 'rails_best_practices', '0.5.0'
  gem 'rcov', '0.9.9'
  gem 'ruby2ruby', '1.2.5'
  gem 'reek', '1.2.8'
  gem 'roodi', '2.1.0'
  gem 'json_pure', '1.4.6'
  gem 'rubyforge', '2.0.4'
  gem 'hoe', '2.7.0'
  gem 'chronic', '0.2.3'
  gem 'hirb', '0.3.5'
  gem 'fattr', '2.2.0'
  gem 'main', '4.3.0'
  gem 'sexp_processor', '3.0.5'
  gem 'ruby_parser', '2.0.5'
  gem 'churn', '0.0.12'
  gem 'colored', '1.2'
  gem 'arrayfields', '4.7.4'
  gem 'Saikuro', '1.1.0' unless Config::CONFIG['RUBY_PROGRAM_VERSION'] == '1.9.2'
  gem 'activesupport', '3.0.1'
  gem 'i18n', '>=0.4.2'
end

group :benchmark do
  gem 'right_aws', '2.0.0'
  gem 'right_http_connection', '1.2.4'
  gem 'xml-simple', '1.0.12'
  gem 'aws-s3', '0.6.2', :require => 'aws/s3'
end

group :development do
  gem 'rake', '0.8.7'
  gem 'grit', '2.3.0'
  gem 'builder', '2.1.2'
  gem 'excon', '>= 0.2.4'
  gem 'formatador', '>= 0.0.15'
  gem 'mime-types', '1.16'
  gem 'json', '1.4.6'
  gem 'net-ssh', '~> 2.0.23'
  gem 'nokogiri', '~> 1.4.3.1'
  gem 'ruby-hmac', '0.4.0'
  gem 'launchy', '0.3.7' unless Config::CONFIG['target_os'] =~ /mswin/i
  gem 'open_gem', '1.4.2' unless Config::CONFIG['target_os'] =~ /mswin/i
  gem 'thor', '0.14.4' unless Config::CONFIG['target_os'] =~ /mswin/i
  gem 'ffi', '0.6.3' if Config::CONFIG['target_os'] =~ /linux/i
  gem 'guard', '0.2.2' unless Config::CONFIG['target_os'] =~ /mswin/i
  gem 'guard-shell', '0.1.1'  unless Config::CONFIG['target_os'] =~ /mswin/i
  gem 'guard-bundler', '0.1.1'  unless Config::CONFIG['target_os'] =~ /mswin/i
  gem 'libnotify', '0.3.0' if Config::CONFIG['target_os'] =~ /linux/i
  gem 'rb-inotify', '0.8.1' if Config::CONFIG['target_os'] =~ /linux/i
  gem 'growl' if Config::CONFIG['target_os'] =~ /darwin/i
  gem 'rb-fsevent' if Config::CONFIG['target_os'] =~ /darwin/i
end

group :debug do
  gem 'ruby_core_source', '0.1.4'
  gem 'archive-tar-minitar', '0.5.2'
  gem 'columnize', '0.3.1'
  gem 'linecache19', '0.5.11'
  gem 'ruby-debug19', :require => 'ruby-debug' if Config::CONFIG['RUBY_PROGRAM_VERSION'] =~ /1\.9/
  gem 'ruby-debug-base19' if Config::CONFIG['RUBY_PROGRAM_VERSION'] =~ /1\.9/
  gem 'ruby-debug-ide19', '~>0.4.10', :require => 'ruby-debug-ide' if Config::CONFIG['RUBY_PROGRAM_VERSION'] =~ /1\.9/
  gem 'ruby-debug-ide', '~>0.4.10' if Config::CONFIG['RUBY_PROGRAM_VERSION'] =~ /1\.8/
end