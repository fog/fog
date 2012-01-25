class AWS < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :auto_scaling
        Fog::AWS::AutoScaling
      when :cdn
        Fog::CDN::AWS
      when :cloud_formation
        Fog::AWS::CloudFormation
      when :cloud_watch
        Fog::AWS::CloudWatch
      when :compute
        Fog::Compute::AWS
      when :ddb, :dynamodb
        Fog::AWS::DynamoDB
      when :dns
        Fog::DNS::AWS
      when :elasticache
        Fog::AWS::Elasticache
      when :elb
        Fog::AWS::ELB
      when :emr
        Fog::AWS::EMR
      when :iam
        Fog::AWS::IAM
      when :sdb, :simpledb
        Fog::AWS::SimpleDB
      when :ses
        Fog::AWS::SES
      when :sqs
        Fog::AWS::SQS
      when :eu_storage, :storage
        Fog::Storage::AWS
      when :rds
        Fog::AWS::RDS
      when :sns
        Fog::AWS::SNS
      when :sts
        Fog::AWS::STS
      else
        # @todo Replace most instances of ArgumentError with NotImplementedError
        # @todo For a list of widely supported Exceptions, see:
        # => http://www.zenspider.com/Languages/Ruby/QuickRef.html#35
        raise ArgumentError, "Unsupported #{self} service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :auto_scaling
          Fog::AWS::AutoScaling.new
        when :cdn
          Fog::Logger.warning("AWS[:cdn] is not recommended, use CDN[:aws] for portability")
          Fog::CDN.new(:provider => 'AWS')
        when :cloud_formation
          Fog::AWS::CloudFormation.new
        when :cloud_watch
          Fog::AWS::CloudWatch.new
        when :compute
          Fog::Logger.warning("AWS[:compute] is not recommended, use Compute[:aws] for portability")
          Fog::Compute.new(:provider => 'AWS')
        when :ddb, :dynamodb
          Fog::AWS::DynamoDB.new
        when :dns
          Fog::Logger.warning("AWS[:dns] is not recommended, use DNS[:aws] for portability")
          Fog::DNS.new(:provider => 'AWS')
        when :elasticache
          Fog::AWS::Elasticache.new
        when :elb
          Fog::AWS::ELB.new
        when :emr
          Fog::AWS::EMR.new
        when :iam
          Fog::AWS::IAM.new
        when :rds
          Fog::AWS::RDS.new
        when :eu_storage
          Fog::Storage.new(:provider => 'AWS', :region => 'eu-west-1')
        when :sdb, :simpledb
          Fog::AWS::SimpleDB.new
        when :ses
          Fog::AWS::SES.new
        when :sqs
          Fog::AWS::SQS.new
        when :storage
          Fog::Logger.warning("AWS[:storage] is not recommended, use Storage[:aws] for portability")
          Fog::Storage.new(:provider => 'AWS')
        when :sns
          Fog::AWS::SNS.new
        when :sts
          Fog::AWS::STS.new
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::AWS.services
    end

  end
end
