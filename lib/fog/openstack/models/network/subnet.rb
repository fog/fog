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
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end

        def save
          requires :network_id, :cidr, :ip_version
          identity ? update : create
        end

        def create
          requires :network_id, :cidr, :ip_version
          merge_attributes(service.create_subnet(self.network_id,
                                                    self.cidr,
                                                    self.ip_version,
                                                    self.attributes).body['subnet'])
          self
        end

        def update
          requires :id, :network_id, :cidr, :ip_version
          merge_attributes(service.update_subnet(self.id,
                                                    self.attributes).body['subnet'])
          self
        end

        def destroy
          requires :id
          service.delete_subnet(self.id)
          true
        end
      end
    end
  end
end
