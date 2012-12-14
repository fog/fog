require 'fog/core/collection'
require 'fog/openstack/models/network/floatingip'

module Fog
  module Network
    class OpenStack
      class Floatingips < Fog::Collection

        attribute :filters

        model Fog::Network::OpenStack::Floatingip

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          load(connection.list_floatingips(filters).body['floatingips'])
        end

        def get(floating_network_id)
          if floatingip = connection.get_floatingip(floating_network_id).body['floatingip']
            new(floatingip)
          end
        rescue Fog::Network::OpenStack::NotFound
          nil
        end

      end
    end
  end
end
