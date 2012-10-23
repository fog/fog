require 'fog/core/model'

module Fog
  module Compute
    class GCE

      class Server < Fog::Model

        identity :name

        attribute :image_name, :aliases => 'image'
        attribute :network_interfaces, :aliases => 'networkInterfaces'
        attribute :state, :aliases => 'status'
        attribute :zone_name, :aliases => 'zone'
        attribute :machine_type, :aliases => 'machineType'

        def destroy
          requires :identity
          connection.delete_server(identity)
        end

        def image
          connection.get_image(self.image_name.split('/')[-1])
        end

        def public_ip_address
          self.network_interfaces[0]["networkIP"]
        end

        def ready?
          self.state == RUNNING_STATE
        end

        def zone
          connection.get_zone(self.zone_name.split('/')[-1])
        end

        def save
          requires :identity
          requires :image_name
          requires :zone_name
          requires :machine_type

          data = connection.insert_server(identity, image_name=image_name,
                                          zone_name=zone_name,
                                          machine_type=machine_type)
          connection.servers.merge_attributes()
        end

      end
    end
  end
end
