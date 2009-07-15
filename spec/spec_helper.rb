require 'spec'

require "#{File.dirname(__FILE__)}/../lib/fog"

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

module Spec
  module Matchers
    class Eventually #:nodoc:
      def initialize(&block)
        @block = block
      end

      def matches?(given_proc)
        match = nil
        [0,2,4,8,16].each do |delay|
          begin
            sleep(delay)
            match = @block[given_proc.call]
            break
          rescue Spec::Expectations::ExpectationNotMetError => error
            raise error if delay == 16
          end
        end
        match
      end
    end

    # :call-seq
    #   should eventually() { |expected| ... }
    # Matches if block matches within 30 seconds
    #
    # == Examples
    #
    #   lambda { do_something_eventually_returning_true }.should eventually {|expected| expected.should be_true }
    #
    #   lambda { do_something_eventually_returning_false }.should_not eventually {|expected| expected.should_not be_true }
    def eventually(&block)
      Matchers::Eventually.new(&block)
    end
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
