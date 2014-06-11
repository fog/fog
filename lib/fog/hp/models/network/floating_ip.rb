require 'fog/core/model'

module Fog
  module HP
    class Network
      class FloatingIp < Fog::Model
        identity :id

        attribute :floating_network_id
        attribute :port_id
        attribute :tenant_id
        attribute :router_id
        attribute :fixed_ip_address
        attribute :floating_ip_address

        def destroy
          requires :id
          service.delete_floating_ip(id)
          true
        end

        def associate_port(port_id, options={})
          requires :id
          merge_attributes(service.associate_floating_ip(id, port_id, options).body['floatingip'])
          true
        end

        def disassociate_port(options={})
          requires :id
          merge_attributes(service.disassociate_floating_ip(id, options).body['floatingip'])
          true
        end

        def save
          requires :floating_network_id
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          merge_attributes(service.create_floating_ip(floating_network_id, attributes).body['floatingip'])
          true
        end
      end
    end
  end
end
