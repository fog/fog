require 'fog/core/model'

module Fog
  module HP
    class Network
      class Subnet < Fog::Model
        identity :id

        attribute :name
        attribute :network_id
        attribute :cidr
        attribute :ip_version
        attribute :tenant_id
        attribute :dns_nameservers
        attribute :allocation_pools
        attribute :host_routes
        attribute :gateway_ip
        attribute :enable_dhcp

        def destroy
          requires :id
          service.delete_subnet(id)
          true
        end

        def save
          requires :network_id, :cidr, :ip_version
          identity ? update : create
        end

        private

        def create
          requires :network_id, :cidr, :ip_version
          merge_attributes(service.create_subnet(network_id, cidr, ip_version, attributes).body['subnet'])
          true
        end

        def update
          requires :id
          merge_attributes(service.update_subnet(id, attributes).body['subnet'])
          true
        end
      end
    end
  end
end
