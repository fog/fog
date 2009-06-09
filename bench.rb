require 'rubygems'
require 'benchwarmer'
require 'right_aws'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
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

Benchmark.bm(25) do |bench|
  bench.report('fog.put_bucket') do
    fog.put_bucket('fogbench')
  end
  bench.report('raws.create_bucket') do
    raws.create_bucket('rawsbench')
  end

  print '-' * 64 << "\n"

  bench.report('fog.put_object') do
    file = File.open(File.dirname(__FILE__) + '/spec/lorem.txt', 'r')
    fog.put_object('fogbench', 'lorem', file)
  end
  bench.report('raws.put') do
    file = File.open(File.dirname(__FILE__) + '/spec/lorem.txt', 'r')
    raws.put('rawsbench', 'lorem', file)
  end

  print '-' * 64 << "\n"

  bench.report('fog.delete_object') do
    fog.delete_object('fogbench', 'lorem')
  end
  bench.report('raws.delete') do
    raws.delete('rawsbench', 'lorem')
  end

  print '-' * 64 << "\n"

  bench.report('fog.delete_bucket') do
    fog.delete_bucket('fogbench')
  end
  bench.report('raws.delete_bucket') do
    raws.delete_bucket('rawsbench')
  end
end