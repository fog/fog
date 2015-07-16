require 'fog/openstack/models/model'

module Fog
  module Network
    class OpenStack
      class FloatingIp < Fog::OpenStack::Model
        identity :id

        attribute :floating_network_id
        attribute :port_id
        attribute :tenant_id
        attribute :fixed_ip_address
        attribute :floating_ip_address

        def initialize(attributes)
          @connection = attributes[:connection]
          super
        end

        def create
          requires :floating_network_id
          merge_attributes(service.create_floating_ip(self.floating_network_id,

                                                    self.attributes).body['floatingip'])
          self
        end

        def update
          self
        end

        def destroy
          requires :id
          service.delete_floating_ip(self.id)
          true
        end
      end
    end
  end
end
