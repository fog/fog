require 'fog/core/model'

module Fog
  module Compute
    class Google

      class Server < Fog::Compute::Server

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
          data = service.get_server(self.name, self.zone_name).body
          data.delete("zone")
          data.delete("machineType")
          data.delete("image")
          data.delete("networkInterfaces")
          self.merge_attributes(data)
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

          data = service.get_server(self.name, self.zone_name).body
          data.delete("zone")
          data.delete("machineType")
          data.delete("image")
          data.delete("networkInterfaces")
          service.servers.merge_attributes(data)
        end

        def setup(credentials = {})
          requires :public_ip_address, :identity, :public_key, :username
          Fog::SSH.new(public_ip_address, username, credentials).run([
            %{mkdir .ssh},
            %{echo "#{public_key}" >> ~/.ssh/authorized_keys},
          ])
        rescue Errno::ECONNREFUSED
          sleep(1)
          retry
        end
      end
    end
  end
end
