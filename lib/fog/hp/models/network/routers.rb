require 'fog/core/collection'
require 'fog/hp/models/network/router'

module Fog
  module HP
    class Network

      class Routers < Fog::Collection

        attribute :filters

        model Fog::HP::Network::Router

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          load(service.list_routers(filters).body['routers'])
        end

        def get(router_id)
          if router = service.get_router(router_id).body['router']
            new(router)
          end
        rescue Fog::HP::Network::NotFound
          nil
        end

      end
    end
  end
end
