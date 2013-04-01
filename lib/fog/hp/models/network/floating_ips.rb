require 'fog/core/collection'
require 'fog/hp/models/network/floating_ip'

module Fog
  module HP
    class Network

      class FloatingIps < Fog::Collection

        attribute :filters

        model Fog::HP::Network::FloatingIp

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          load(service.list_floating_ips(filters).body['floatingips'])
        end

        def get(floating_ip_id)
          if floating_ip = service.get_floating_ip(floating_ip_id).body['floatingip']
            new(floating_ip)
          end
        rescue Fog::HP::Network::NotFound
          nil
        end

      end
    end
  end
end
