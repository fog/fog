require 'fog/core/collection'
require 'fog/aws/models/elasticache/security_group'

module Fog
  module AWS
    class Elasticache

      class SecurityGroups < Fog::Collection
        model Fog::AWS::Elasticache::SecurityGroup

        def all
          data = connection.describe_cache_security_groups.body['CacheSecurityGroups']
          load(data)
        end

        def get(identity)
          data = connection.describe_cache_security_groups('CacheSecurityGroupName' => identity).body['CacheSecurityGroups'].first
          new(data)
        rescue Fog::AWS::Elasticache::NotFound
          nil
        end
      end

    end
  end
end

