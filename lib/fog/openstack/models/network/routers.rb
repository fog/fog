require 'fog/core/collection'
require 'fog/openstack/models/network/router'

module Fog
  module Network
    class OpenStack
      class Routers < Fog::Collection
        attribute :filters

        model Fog::Network::OpenStack::Router

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          filters = filters_arg
          load(service.list_routers(filters).body['routers'])
        end

        alias_method :summary, :all

        def get(router_id)
          if router = service.get_router(router_id).body['router']
            new(router)
          end
        rescue Fog::Network::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
