require "spec_helper"
require "fog/bin"
require "helpers/bin"

describe AWS do
  include Fog::BinSpec

  let(:subject) { AWS }

  KEY_CLASS_MAPPING = {
    :auto_scaling => Fog::AWS::AutoScaling,
    :beanstalk => Fog::AWS::ElasticBeanstalk,
    :cdn => Fog::CDN::AWS,
    :cloud_formation => Fog::AWS::CloudFormation,
    :cloud_watch => Fog::AWS::CloudWatch,
    :compute => Fog::Compute::AWS,
    :data_pipeline => Fog::AWS::DataPipeline,
    :ddb => Fog::AWS::DynamoDB,
    :dynamodb => Fog::AWS::DynamoDB,
    :dns => Fog::DNS::AWS,
    :elasticache => Fog::AWS::Elasticache,
    :elb => Fog::AWS::ELB,
    :emr => Fog::AWS::EMR,
    :glacier => Fog::AWS::Glacier,
    :iam => Fog::AWS::IAM,
    :redshift => Fog::AWS::Redshift,
    :sdb => Fog::AWS::SimpleDB,
    :simpledb => Fog::AWS::SimpleDB,
    :ses => Fog::AWS::SES,
    :sqs => Fog::AWS::SQS,
    :eu_storage => Fog::Storage::AWS,
    :storage => Fog::Storage::AWS,
    :rds => Fog::AWS::RDS,
    :sns => Fog::AWS::SNS,
    :sts => Fog::AWS::STS
  }

  describe "#services" do
    it "includes all services" do
      assert_includes AWS.services, :auto_scaling
      assert_includes AWS.services, :beanstalk
      assert_includes AWS.services, :cdn
      assert_includes AWS.services, :cloud_formation
      assert_includes AWS.services, :cloud_watch
      assert_includes AWS.services, :compute
      assert_includes AWS.services, :data_pipeline
      assert_includes AWS.services, :dynamodb
      assert_includes AWS.services, :dns
      assert_includes AWS.services, :elasticache
      assert_includes AWS.services, :elb
      assert_includes AWS.services, :emr
      assert_includes AWS.services, :glacier
      assert_includes AWS.services, :iam
      assert_includes AWS.services, :redshift
      assert_includes AWS.services, :rds
      assert_includes AWS.services, :simpledb
      assert_includes AWS.services, :ses
      assert_includes AWS.services, :sqs
      assert_includes AWS.services, :storage
      assert_includes AWS.services, :sns
      assert_includes AWS.services, :sts
    end
  end

  describe "#class_for" do
    describe "when key exists" do
      it "maps to correct class" do
        KEY_CLASS_MAPPING.each do |key, klass|
          assert_equal klass, AWS.class_for(key)
        end
      end
    end

    describe "when key does not exist" do
      it "raises ArgumentError" do
        assert_raises(ArgumentError) { AWS.class_for(:bad_key) }
      end
    end
  end
end
