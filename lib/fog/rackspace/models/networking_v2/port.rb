module Fog
  module Rackspace
    class NetworkingV2
      class Port < Fog::Model

        identity :id

        attribute :admin_state_up
        attribute :device_id
        attribute :device_owner
        attribute :fixed_ips
        attribute :mac_address
        attribute :name
        attribute :network_id
        attribute :security_groups
        attribute :status
        attribute :tenant_id

        def save
          data = unless self.id.nil?
            service.update_port(self)
          else
            service.create_port(self)
          end

          merge_attributes(data.body['port'])
          true
        end

        def destroy
          requires :identity

          service.delete_port(identity)
          true
        end
      end
    end
  end
end
