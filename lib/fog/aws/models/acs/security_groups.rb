require 'fog/core/collection'
require 'fog/aws/models/acs/security_group'

module Fog
  module AWS
    class ACS

      class SecurityGroups < Fog::Collection
        model Fog::AWS::ACS::SecurityGroup

        def all
          data = connection.describe_cache_security_groups.body['CacheSecurityGroups']
          load(data)
        end

        def get(identity)
          data = connection.describe_cache_security_groups('CacheSecurityGroupName' => identity).body['CacheSecurityGroups'].first
          new(data)
        rescue Fog::AWS::ACS::NotFound
          nil
        end
      end

    end
  end
end

