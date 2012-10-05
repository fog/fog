require 'fog/core/model'

module Fog
  module Network
    class OpenStack
      class Subnet < Fog::Model
        identity :id

        attribute :name
        attribute :network_id
        attribute :cidr
        attribute :ip_version
        attribute :gateway_ip
        attribute :allocation_pools
        attribute :dns_nameservers
        attribute :host_routes
        attribute :enable_dhcp
        attribute :tenant_id

        def initialize(attributes)
          @connection = attributes[:connection]
          super
        end

        def save
          requires :network_id, :cidr, :ip_version
          identity ? update : create
        end

        def create
          requires :network_id, :cidr, :ip_version
          merge_attributes(connection.create_subnet(self.network_id,
                                                    self.cidr,
                                                    self.ip_version,
                                                    self.attributes).body['subnet'])
          self
        end

        def update
          requires :id, :network_id, :cidr, :ip_version
          merge_attributes(connection.update_subnet(self.id,
                                                    self.attributes).body['subnet'])
          self
        end

        def destroy
          requires :id
          connection.delete_subnet(self.id)
          true
        end

      end
    end
  end
end