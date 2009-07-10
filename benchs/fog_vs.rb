require 'rubygems'
require 'benchmark'
require 'right_aws'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'fog/aws'

data = File.open(File.expand_path('~/.s3conf/s3config.yml')).read
config = YAML.load(data)
fog = Fog::AWS::S3.new(
  :aws_access_key_id => config['aws_access_key_id'],
  :aws_secret_access_key => config['aws_secret_access_key']
)
raws = RightAws::S3Interface.new(
  config['aws_access_key_id'],
  config['aws_secret_access_key']
)
raws.logger.level = 3 # ERROR

TIMES = 10

Benchmark.bmbm(25) do |bench|
  bench.report('fog.put_bucket') do
    TIMES.times do |x|
      fog.put_bucket("fogbench#{x}")
    end
  end
  bench.report('raws.create_bucket') do
    TIMES.times do |x|
      raws.create_bucket("rawsbench#{x}")
    end
  end

  bench.report('fog.put_object') do
    TIMES.times do |x|
      TIMES.times do |y|
        file = File.open(File.dirname(__FILE__) + '/../spec/lorem.txt', 'r')
        fog.put_object("fogbench#{x}", "lorem_#{y}", file)
      end
    end
  end
  bench.report('raws.put') do
    TIMES.times do |x|
      TIMES.times do |y|
        file = File.open(File.dirname(__FILE__) + '/../spec/lorem.txt', 'r')
        raws.put("rawsbench#{x}", "lorem_#{y}", file)
      end
    end
  end

  bench.report('fog.delete_object') do
    TIMES.times do |x|
      TIMES.times do |y|
        fog.delete_object("fogbench#{x}", "lorem_#{y}")
      end
    end
  end
  bench.report('raws.delete') do
    TIMES.times do |x|
      TIMES.times do |y|
        raws.delete("rawsbench#{x}", "lorem_#{y}")
      end
    end
  end

  bench.report('fog.delete_bucket') do
    TIMES.times do |x|
      fog.delete_bucket("fogbench#{x}")
    end
  end
  bench.report('raws.delete_bucket') do
    TIMES.times do |x|
      raws.delete_bucket("rawsbench#{x}")
    end
  end
end
