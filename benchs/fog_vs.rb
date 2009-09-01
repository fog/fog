require 'rubygems'
require 'aws/s3'
require 'benchmark'
require 'right_aws'

require File.join(File.dirname(__FILE__), '..', 'lib', 'fog')

data = File.open(File.join(File.dirname(__FILE__), '..', 'spec', 'credentials.yml')).read
config = YAML.load(data)
fog = Fog::AWS::S3.new(
  :aws_access_key_id     => config['aws_access_key_id'],
  :aws_secret_access_key => config['aws_secret_access_key']
)
raws = RightAws::S3Interface.new(
  config['aws_access_key_id'],
  config['aws_secret_access_key']
)
raws.logger.level = 3 # ERROR
awss3 = AWS::S3::Base.establish_connection!(
  :access_key_id     => config['aws_access_key_id'],
  :secret_access_key => config['aws_secret_access_key'],
  :persistent        => true
)

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
  bench.report('awss3::Bucket.create') do
    TIMES.times do |x|
      AWS::S3::Bucket.create("awss3bench#{x}")
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
  bench.report('awss3::S3Object.create') do
    TIMES.times do |x|
      TIMES.times do |y|
        file = File.open(File.dirname(__FILE__) + '/../spec/lorem.txt', 'r')
        AWS::S3::S3Object.create("lorem_#{y}", file, "awss3bench#{x}")
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
  bench.report('awss3::S3Object.delete') do
    TIMES.times do |x|
      TIMES.times do |y|
        AWS::S3::S3Object.delete("lorem_#{y}", "awss3bench#{x}")
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
  bench.report('awss3::Bucket.delete') do
    TIMES.times do |x|
      AWS::S3::Bucket.delete("awss3bench#{x}")
    end
  end
end

# Rehearsal ------------------------------------------------------------
# fog.put_bucket             0.010000   0.000000   0.010000 (  4.981517)
# raws.create_bucket         0.030000   0.040000   0.070000 ( 10.035029)
# awss3::Bucket.create       0.020000   0.020000   0.040000 (  7.402162)
# fog.put_object             0.080000   0.080000   0.160000 (  8.757062)
# raws.put                   0.180000   0.080000   0.260000 ( 12.307371)
# awss3::S3Object.create     0.170000   0.070000   0.240000 ( 14.028887)
# fog.delete_object          0.080000   0.050000   0.130000 (  5.481744)
# raws.delete                0.140000   0.070000   0.210000 (  7.709116)
# awss3::S3Object.delete     0.100000   0.040000   0.140000 (  5.533884)
# fog.delete_bucket          0.010000   0.010000   0.020000 (  1.861061)
# raws.delete_bucket         0.030000   0.020000   0.050000 (  3.146836)
# awss3::Bucket.delete       0.050000   0.010000   0.060000 (  1.877064)
# --------------------------------------------------- total: 1.390000sec
# 
#                                user     system      total        real
# fog.put_bucket             0.010000   0.020000   0.030000 (  1.949933)
# raws.create_bucket         0.030000   0.020000   0.050000 (  4.766058)
# awss3::Bucket.create       0.010000   0.010000   0.020000 (  2.093764)
# fog.put_object             0.090000   0.080000   0.170000 (  9.352868)
# raws.put                   0.150000   0.080000   0.230000 ( 12.981112)
# awss3::S3Object.create     0.130000   0.070000   0.200000 ( 14.442972)
# fog.delete_object          0.060000   0.060000   0.120000 (  5.657752)
# raws.delete                0.130000   0.050000   0.180000 (  6.598221)
# awss3::S3Object.delete     0.110000   0.030000   0.140000 (  5.709799)
# fog.delete_bucket          0.010000   0.010000   0.020000 (  1.864573)
# raws.delete_bucket         0.040000   0.030000   0.070000 (  4.120572)
# awss3::Bucket.delete       0.020000   0.000000   0.020000 (  1.947711)
