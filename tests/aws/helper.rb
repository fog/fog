module AWS

  class << self
    def [](service)
      @@connections ||= Hash.new do |hash, key|
        credentials = Fog.credentials.reject do |k, v|
          ![:aws_access_key_id, :aws_secret_access_key].include?(k)
        end
        hash[key] = case key
        when :compute
          Fog::AWS::Compute.new(credentials)
        when :eu_storage
          Fog::AWS::Storage.new(credentials.merge!(:host => 's3-external-3.amazonaws.com'))
        when :sdb
          Fog::AWS::SimpleDB.new(credentials)
        when :storage
          Fog::AWS::Storage.new(credentials)
        end
      end
      @@connections[service]
    end
  end

  module Compute

    module Formats

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
