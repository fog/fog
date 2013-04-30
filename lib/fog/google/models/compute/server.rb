require 'fog/core/model'

module Fog
  module Compute
    class Google

      class Server < Fog::Model

        identity :name
        attribute :image_name, :aliases => 'image'
        attribute :network_interfaces, :aliases => 'networkInterfaces'
        attribute :state, :aliases => 'status'
        attribute :zone_name, :aliases => 'zone'
        attribute :machine_type, :aliases => 'machineType'

        def destroy
          requires :name
          service.delete_server(name)
        end

        def image
          service.get_image(self.image_name.split('/')[-1])
        end

        def public_ip_address
          self.network_interfaces[0]["networkIP"]
        end

        def ready?
          self.state == RUNNING_STATE
        end

        def zone
          service.get_zone(self.zone_name.split('/')[-1])
        end

        def save
          requires :name
          requires :image_name
          requires :machine_type
          requires :zone_name

          data = service.insert_server(
            name,
            image_name,
            zone_name,
            machine_type)

          service.servers.merge_attributes()
        end

      end
    end
  end
end
