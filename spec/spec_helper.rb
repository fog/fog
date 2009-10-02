require 'spec'

current_directory = File.dirname(__FILE__)
require "#{current_directory}/../lib/fog"
# Fog.mock!

def credentials
  @credentials ||= begin
    credentials_path = File.expand_path('~/.fog')
    credentials_data = File.open(credentials_path).read
    YAML.load(credentials_data)
  end
end

def ec2
  Fog::AWS::EC2.new(
    :aws_access_key_id => credentials['aws_access_key_id'],
    :aws_secret_access_key => credentials['aws_secret_access_key']
  )
end

def eu_s3
  Fog::AWS::S3.new(
    :aws_access_key_id => credentials['aws_access_key_id'],
    :aws_secret_access_key => credentials['aws_secret_access_key'],
    :host => 's3-external-3.amazonaws.com'
  )
end

def sdb
  Fog::AWS::SimpleDB.new(
    :aws_access_key_id => credentials['aws_access_key_id'],
    :aws_secret_access_key => credentials['aws_secret_access_key']
  )
end

def s3
  Fog::AWS::S3.new(
    :aws_access_key_id => credentials['aws_access_key_id'],
    :aws_secret_access_key => credentials['aws_secret_access_key']
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