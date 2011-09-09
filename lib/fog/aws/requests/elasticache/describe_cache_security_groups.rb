module Fog
  module AWS
    class Elasticache
      class Real

        require 'fog/aws/parsers/elasticache/describe_security_groups'

        # Returns a list of CacheSecurityGroup descriptions
        #
        # === Parameters (optional)
        # * name <~String> - The name of an existing cache security group
        # * options <~Hash> (optional):
        # *  :marker <~String> - marker provided in the previous request
        # *  :max_records <~Integer> - the maximum number of records to include
        def describe_cache_security_groups(name = nil, options = {})
          request({
            'Action'                  => 'DescribeCacheSecurityGroups',
            'CacheSecurityGroupName'  => name,
            'Marker'                  => options[:marker],
            'MaxRecords'              => options[:max_records],
            :parser => Fog::Parsers::AWS::Elasticache::DescribeSecurityGroups.new
          }.merge(options))
        end

      end

      class Mock
        def describe_cache_security_groups(name = nil, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
