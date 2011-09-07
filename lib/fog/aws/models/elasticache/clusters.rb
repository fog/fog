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

        def get(identity)
          new(
            connection.describe_cache_security_groups(
              'CacheSecurityGroupName' => identity
            ).body['CacheSecurityGroups'].first
          )
        rescue Fog::AWS::Elasticache::NotFound
          nil
        end
      end

    end
  end
end
