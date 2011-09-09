require 'fog/core/collection'
require 'fog/aws/models/elasticache/cluster'

module Fog
  module AWS
    class Elasticache

      class Clusters < Fog::Collection
        model Fog::AWS::Elasticache::Cluster

        def all
          load(
            connection.describe_cache_clusters.body['CacheClusters']
          )
        end

        def get(identity, show_node_info = false)
          new(
            connection.describe_cache_clusters(
              identity, :show_node_info => show_node_info
            ).body['CacheClusters'].first
          )
        rescue Fog::AWS::Elasticache::NotFound
        end
      end

    end
  end
end
