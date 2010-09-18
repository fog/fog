require 'spec'
require 'open-uri'
require 'fog'
require 'fog/bin'
require 'fog/vcloud/bin'

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

module AWS
  class << self
    def [](service)
      @@connections ||= Hash.new do |hash, key|
        credentials = Fog.credentials.reject do |k, v|
          ![:aws_access_key_id, :aws_secret_access_key].include?(k)
        end
        hash[key] = case key
        when :compute
          Fog::AWS::Compute.new(credentials)
        when :eu_storage
          Fog::AWS::Storage.new(credentials.merge!(:host => 's3-external-3.amazonaws.com'))
        when :sdb
          Fog::AWS::SimpleDB.new(credentials)
        when :storage
          Fog::AWS::Storage.new(credentials)
        end
      end
      @@connections[service]
    end
  end
end

module Rackspace
  class << self
    def [](service)
      @@connections ||= Hash.new do |hash, key|
        credentials = Fog.credentials.reject do |k, v|
          ![:rackspace_api_key, :rackspace_username].include?(k)
        end
        hash[key] = case key
        when :compute
          Fog::Rackspace::Compute.new(credentials)
        when :storage
          Fog::Rackspace::Storage.new(credentials)
        end
      end
      @@connections[service]
    end
  end
end

module Slicehost
  class << self
    def [](service)
      @@connections ||= Hash.new do |hash, key|
        credentials = Fog.credentials.reject do |k, v|
          ![:slicehost_password].include?(k)
        end
        hash[key] = case key
        when :compute
          Fog::Slicehost::Compute.new(credentials)
        end
      end
      @@connections[service]
    end
  end
end

module Bluebox
  class << self
    def [](service)
      @@connections ||= Hash.new do |hash, key|
        credentials = Fog.credentials.reject do |k,v|
          ![:bluebox_api_key, :bluebox_customer_id].include?(k)
        end
        hash[key] = case key
        when :compute
          Fog::Bluebox::Compute.new(credentials)
        end
      end
      @@connections[service]
    end
  end
end

module Google
  class << self
    def [](service)
      @@connections ||= Hash.new do |hash, key|
        credentials = Fog.credentials.reject do |k, v|
          ![:google_storage_access_key_id, :google_storage_secret_access_key].include?(k)
        end
        hash[key] = case key
        when :storage
          Fog::Google::Storage.new(credentials)
        end
      end
      @@connections[service]
    end
  end
end

def eventually(max_delay = 16, &block)
  delays = [0]
  delay_step = 1
  total = 0
  while true
    delay = 1
    delay_step.times do
      delay *= 2
    end
    delays << delay
    delay_step += 1
    break if delay >= max_delay
  end
  delays.each do |delay|
    begin
      sleep(delay)
      yield
      break
    rescue => error
      raise error if delay >= max_delay
    end
  end
end

unless defined?(GENTOO_AMI)
  GENTOO_AMI = 'ami-5ee70037'
end

def lorem_file
  File.open(File.dirname(__FILE__) + '/lorem.txt', 'r')
end
