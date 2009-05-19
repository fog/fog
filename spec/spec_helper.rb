require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'fog'

Spec::Runner.configure do |config|
  
end

require 'fog/aws'

def sdb
  @sdb ||= begin
    data = File.open(File.expand_path('~/.s3conf/s3config.yml')).read
    config = YAML.load(data)
    Fog::AWS::SimpleDB.new(
      :aws_access_key_id => config['aws_access_key_id'],
      :aws_secret_access_key => config['aws_secret_access_key']
    )
  end
end
def s3
  @s3 ||= begin
    data = File.open(File.expand_path('~/.s3conf/s3config.yml')).read
    config = YAML.load(data)
    Fog::AWS::S3.new(
      :aws_access_key_id => config['aws_access_key_id'],
      :aws_secret_access_key => config['aws_secret_access_key']
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
    #   lambda { do_something_eventually_returning_false }.should eventually {|expected| expected.should_not be_true }
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
