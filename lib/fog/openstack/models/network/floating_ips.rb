require 'fog/core/collection'
require 'fog/openstack/models/network/floating_ip'

module Fog
  module Network
    class OpenStack
      class FloatingIps < Fog::Collection

        attribute :filters

        model Fog::Network::OpenStack::FloatingIp

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          load(connection.list_floating_ips(filters).body['floating_ips'])
        end

        def get(floating_network_id)
          if floating_ip = connection.get_floating_ip(floating_network_id).body['floating_ip']
            new(floating_ip)
          end
        rescue Fog::Network::OpenStack::NotFound
          nil
        end

      end
    end
  end
end
