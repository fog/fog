require 'spec'

current_directory = File.dirname(__FILE__)
require "#{current_directory}/../lib/fog"
# Fog.mocking = true

def credentials
  @credentials ||= begin
    credentials_path = "#{File.dirname(__FILE__)}/credentials.yml"
    credentials_data = File.open(credentials_path).read
    YAML.load(credentials_data)
  end
end

module Fog
  module AWS

    class EC2
      def self.gen
        new(
          :aws_access_key_id => credentials['aws_access_key_id'],
          :aws_secret_access_key => credentials['aws_secret_access_key']
        )
      end
    end

    class S3
      def self.gen(location = nil)
        if location == :eu
          host = 's3-external-3.amazonaws.com'
        end
        new(
          :aws_access_key_id => credentials['aws_access_key_id'],
          :aws_secret_access_key => credentials['aws_secret_access_key'],
          :host => host
        )
      end
    end

    class SimpleDB
      def self.gen
        new(
          :aws_access_key_id => credentials['aws_access_key_id'],
          :aws_secret_access_key => credentials['aws_secret_access_key']
        )
      end
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