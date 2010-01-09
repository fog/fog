require 'spec'
require 'open-uri'

current_directory = File.dirname(__FILE__)
require "#{current_directory}/../lib/fog"
# Fog.mock!

def ec2
  Fog::AWS::EC2.new(
    :aws_access_key_id => Fog.credentials[:aws_access_key_id],
    :aws_secret_access_key => Fog.credentials[:aws_secret_access_key]
  )
end

def eu_s3
  Fog::AWS::S3.new(
    :aws_access_key_id => Fog.credentials[:aws_access_key_id],
    :aws_secret_access_key => Fog.credentials[:aws_secret_access_key],
    :host => 's3-external-3.amazonaws.com'
  )
end

def files
  Fog::Rackspace::Files.new(
    :rackspace_api_key => Fog.credentials[:rackspace_api_key],
    :rackspace_username => Fog.credentials[:rackspace_username]
  )
end

def sdb
  Fog::AWS::SimpleDB.new(
    :aws_access_key_id => Fog.credentials[:aws_access_key_id],
    :aws_secret_access_key => Fog.credentials[:aws_secret_access_key]
  )
end

def s3
  Fog::AWS::S3.new(
    :aws_access_key_id => Fog.credentials[:aws_access_key_id],
    :aws_secret_access_key => Fog.credentials[:aws_secret_access_key]
  )
end

def servers
  Fog::Rackspace::Servers.new(
    :rackspace_api_key => Fog.credentials[:rackspace_api_key],
    :rackspace_username => Fog.credentials[:rackspace_username]
  )
end

def slicehost
  Fog::Slicehost.new(
    :password => Fog.credentials[:slicehost_password]
  )
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