require 'rubygems'
require 'aws/s3'
require 'benchmark'
require 'right_aws'

require File.join(File.dirname(__FILE__), '..', 'lib', 'fog')

data = File.open(File.expand_path('~/.fog')).read
config = YAML.load(data)[:default]
fog = Fog::AWS::S3.new(
  :aws_access_key_id     => config[:aws_access_key_id],
  :aws_secret_access_key => config[:aws_secret_access_key]
)
raws = RightAws::S3Interface.new(
  config[:aws_access_key_id],
  config[:aws_secret_access_key]
)
raws.logger.level = 3 # ERROR
awss3 = AWS::S3::Base.establish_connection!(
  :access_key_id     => config[:aws_access_key_id],
  :secret_access_key => config[:aws_secret_access_key],
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
# fog.put_bucket             0.030000   0.010000   0.040000 (  4.797287)
# raws.create_bucket         0.040000   0.030000   0.070000 ( 10.037626)
# awss3::Bucket.create       0.010000   0.000000   0.010000 (  1.732033)
# fog.put_object             0.350000   0.220000   0.570000 ( 27.430128)
# raws.put                   0.180000   0.050000   0.230000 ( 11.320939)
# awss3::S3Object.create     0.170000   0.040000   0.210000 ( 13.903928)
# fog.delete_object          0.280000   0.170000   0.450000 ( 21.327174)
# raws.delete                0.130000   0.040000   0.170000 (  8.872263)
# awss3::S3Object.delete     0.130000   0.020000   0.150000 (  4.700452)
# fog.delete_bucket          0.030000   0.020000   0.050000 (  3.395838)
# raws.delete_bucket         0.040000   0.020000   0.060000 (  4.616931)
# awss3::Bucket.delete       0.010000   0.010000   0.020000 (  2.152023)
# --------------------------------------------------- total: 2.030000sec
# 
#                                user     system      total        real
# fog.put_bucket             0.030000   0.030000   0.060000 (  4.369874)
# raws.create_bucket         0.040000   0.020000   0.060000 (  5.406727)
# awss3::Bucket.create       0.010000   0.000000   0.010000 (  2.230434)
# fog.put_object             0.310000   0.200000   0.510000 ( 25.419315)
# raws.put                   0.170000   0.050000   0.220000 ( 11.554947)
# awss3::S3Object.create     0.160000   0.030000   0.190000 ( 12.573148)
# fog.delete_object          0.260000   0.160000   0.420000 ( 21.045432)
# raws.delete                0.120000   0.050000   0.170000 ( 16.278677)
# awss3::S3Object.delete     0.090000   0.020000   0.110000 (  4.521777)
# fog.delete_bucket          0.030000   0.020000   0.050000 (  4.028921)
# raws.delete_bucket         0.030000   0.030000   0.060000 (  5.447169)
# awss3::Bucket.delete       0.010000   0.000000   0.010000 (  1.662223)