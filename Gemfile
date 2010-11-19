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
end

group :production do
end

group :rake do
  gem 'rake', '0.8.7'
  gem 'i18n', '>=0.4.2'
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
end

group :rspec do
  gem 'rspec', '~>2.1.0', :require => 'rspec'
end

group :shindo do
  gem 'shindo', '0.1.7'
  gem 'gestalt', '>= 0.0.11'
end

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