module Fog
  module AWS
    class Elasticache
      class Real

        require 'fog/aws/parsers/elasticache/describe_security_groups'

        # Returns a list of CacheSecurityGroup descriptions
        #
        # === Parameters
        # * options <~Hash> (optional):
        # *  CacheSecurityGroupName<~String> - The name of the cache security group
        # *  Marker <~String> - marker provided in the previous request
        # *  MaxRecords <~String> - the maximum number of records to include
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>
        def describe_cache_security_groups(options = {})
          request({
            'Action' => 'DescribeCacheSecurityGroups',
            :parser => Fog::Parsers::AWS::Elasticache::DescribeSecurityGroups.new
          }.merge(options))
        end

      end

      class Mock
        def describe_cache_security_groups
          Fog::Mock.not_implemented
        end
      end
    end
  end
end

