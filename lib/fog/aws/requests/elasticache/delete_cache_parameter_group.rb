module Fog
  module AWS
    class Elasticache
      class Real

        require 'fog/aws/parsers/elasticache/base'

        # deletes a cache parameter group
        #
        # === Parameters
        # * name <~String> - The name for the Cache Parameter Group
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>
        def delete_cache_parameter_group(name)
          request({
            'Action' => 'DeleteCacheParameterGroup',
            'CacheParameterGroupName' => name,
            :parser => Fog::Parsers::AWS::Elasticache::Base.new
          })
        end
      end

      class Mock
        def delete_cache_parameter_group(name)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
