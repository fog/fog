module Fog
  module AWS
    class Elasticache
      class Real

        require 'fog/aws/parsers/elasticache/describe_cache_clusters'

        # Returns a list of CacheCluster descriptions
        #
        # === Parameters
        # * options <~Hash> (optional):
        # *  CacheClusterId<~String> - The name of the cache security group
        # *  Marker <~String> - marker provided in the previous request
        # *  MaxRecords <~String> - the maximum number of records to include
        # *  ShowCacheNodeInfo <~Boolean> - whether to show node info
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>
        def describe_cache_clusters(options = {})
          request({
            'Action' => 'DescribeCacheClusters',
            :parser => Fog::Parsers::AWS::Elasticache::DescribeCacheClusters.new
          }.merge(options))
        end

      end

      class Mock
        def describe_cache_clusters
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
