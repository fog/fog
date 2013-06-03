require 'fog/core/collection'
require 'fog/openstack/models/network/lb_pool'

module Fog
  module Network
    class OpenStack
      class LbPools < Fog::Collection

        attribute :filters

        model Fog::Network::OpenStack::LbPool

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          load(service.list_lb_pools(filters).body['pools'])
        end

        def get(pool_id)
          if pool = service.get_lb_pool(pool_id).body['pool']
            new(pool)
          end
        rescue Fog::Network::OpenStack::NotFound
          nil
        end

      end
    end
  end
end