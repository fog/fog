source :rubygems

gem 'bundler', '~>1.0.3'

#
# Common refers to across production, test and benchmark groups.
#
group :common do
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

#
# Test_common collects gems required by Rspec and Shindo
#
group :test_common do
  gem 'rake', '0.8.7'
  gem 'gestalt', '>= 0.0.11'
end

group :rspec do
  gem 'rspec', '1.3.0', :require => 'spec'
end

group :shindo do
  gem 'shindo', '0.1.7'
end

group :benchmark do
  gem 'right_aws', '2.0.0'
  gem 'right_http_connection', '1.2.4'
  gem 'xml-simple', '1.0.12'
  gem 'aws-s3', '0.6.2', :require => 'aws/s3'
end

group :development do
  gem 'builder', '2.1.2'
  gem 'excon', '>= 0.2.4'
  gem 'formatador', '>= 0.0.15'
  gem 'mime-types', '1.16'
  gem 'json', '1.4.6'
  gem 'net-ssh', '~> 2.0.23'
  gem 'nokogiri', '~> 1.4.3.1'
  gem 'ruby-hmac', '0.4.0'
end
