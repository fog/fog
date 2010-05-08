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

      SNAPSHOT = {
        'description' => NilClass,
        'ownerId'     => String,
        'progress'    => String,
        'snapshotId'  => String,
        'startTime'   => Time,
        'status'      => String,
        'volumeId'    => String,
        'volumeSize'  => Integer
      }

      SNAPSHOTS = {
        'requestId'   => String,
        'snapshotSet' => [SNAPSHOT]
      }

      VOLUME = {
        'availabilityZone'  => String,
        'createTime'        => Time,
        'requestId'         => String,
        'size'              => Integer,
        'snapshotId'        => NilClass,
        'status'            => String,
        'volumeId'          => String
      }

      VOLUME_ATTACHMENT = {
        'attachTime'  => Time,
        'device'      => String,
        'instanceId'  => String,
        'requestId'   => String,
        'status'      => String,
        'volumeId'    => String
      }

      VOLUMES = {
        'volumeSet' => [{
          'availabilityZone'    => String,
          'attachmentSet'       => [],
          'createTime'          => Time,
          'size'                => Integer,
          'snapshotId'          => NilClass,
          'status'              => String,
          'volumeId'            => String
        }],
        'requestId' => String
      }

    end

  end

end

unless defined?(GENTOO_AMI)
  GENTOO_AMI = 'ami-5ee70037'
end