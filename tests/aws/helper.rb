# Boolean hax
module Fog
  module Boolean
  end
end
FalseClass.send(:include, Fog::Boolean)
TrueClass.send(:include, Fog::Boolean)

module AWS

  class << self
    def [](service)
      @@connections ||= Hash.new do |hash, key|
        credentials = Fog.credentials.reject do |k, v|
          ![:aws_access_key_id, :aws_secret_access_key].include?(k)
        end
        hash[key] = case key
        when :ec2
          Fog::AWS::EC2.new(credentials)
        when :eu_s3
          Fog::AWS::S3.new(credentials.merge!(:host => 's3-external-3.amazonaws.com'))
        when :sdb
          Fog::AWS::SimpleDB.new(credentials)
        when :s3
          Fog::AWS::S3.new(credentials)
        end
      end
      @@connections[service]
    end
  end

  module EC2

    module Formats

      ADDRESSES = {
        'addressesSet' => [{
          'instanceId'  => NilClass,
          'publicIp'    => String
        }],
        'requestId' => String
      }

      BASIC = {
        'requestId' => String,
        'return'    => ::Fog::Boolean
      }

    end

  end

end

unless defined?(GENTOO_AMI)
  GENTOO_AMI = 'ami-5ee70037'
end