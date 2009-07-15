require 'spec'

current_directory = File.dirname(__FILE__)
require "#{current_directory}/../lib/fog"
require "#{current_directory}/eventually.rb"

Spec::Runner.configure do |config|
end

def credentials
  @credentials ||= begin
    credentials_path = "#{File.dirname(__FILE__)}/credentials.yml"
    credentials_data = File.open(credentials_path).read
    YAML.load(credentials_data)
  end
end

def ec2
  @ec2 ||= begin
    Fog::AWS::EC2.new(
      :aws_access_key_id => credentials['aws_access_key_id'],
      :aws_secret_access_key => credentials['aws_secret_access_key']
    )
  end
end
def sdb
  @sdb ||= begin
    Fog::AWS::SimpleDB.new(
      :aws_access_key_id => credentials['aws_access_key_id'],
      :aws_secret_access_key => credentials['aws_secret_access_key']
    )
  end
end
def s3
  @s3 ||= begin
    Fog::AWS::S3.new(
      :aws_access_key_id => credentials['aws_access_key_id'],
      :aws_secret_access_key => credentials['aws_secret_access_key']
    )
  end
end

class Eventually
  def initialize(result, delay)
    @result = result
    @delay = delay
  end

  def test
    @start ||= Time.now
    (Time.now - @start <= @delay) ? !@result : @result
  end
end
