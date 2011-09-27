module Fog
  module AWS
    class Elasticache
      class Real

        require 'fog/aws/parsers/elasticache/base'

        # deletes a cache security group
        #
        # === Parameters
        # * name <~String> - The name for the Cache Security Group
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>
        def delete_cache_security_group(name)
          request({
            'Action' => 'DeleteCacheSecurityGroup',
            'CacheSecurityGroupName' => name,
            :parser => Fog::Parsers::AWS::Elasticache::Base.new
          })
        end
      end

      class Mock
        def delete_cache_security_group(name)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
