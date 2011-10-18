module Fog
  module AWS
    class Elasticache
      class Real

        require 'fog/aws/parsers/elasticache/describe_cache_clusters'

        # Returns a list of Cache Cluster descriptions
        #
        # === Parameters (optional)
        # * id - The ID of an existing cache cluster
        # * options <~Hash> (optional):
        # *  :marker <~String> - marker provided in the previous request
        # *  :max_records <~Integer> - the maximum number of records to include
        # *  :show_node_info <~Boolean> - whether to show node info
        # === Returns
        # * response <~Excon::Response>:
        #   * body <~Hash>
        def describe_cache_clusters(id = nil, options = {})
          request({
            'Action'            => 'DescribeCacheClusters',
            'CacheClusterId'    => id,
            'Marker'            => options[:marker],
            'MaxRecords'        => options[:max_records],
            'ShowCacheNodeInfo' => options[:show_node_info],
            :parser => Fog::Parsers::AWS::Elasticache::DescribeCacheClusters.new
          })
        end

      end

      class Mock
        def describe_cache_clusters(id = nil, options = {})
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
