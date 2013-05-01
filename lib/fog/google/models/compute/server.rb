require 'fog/compute/models/server'
require 'net/ssh/proxy/command'

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
        attribute :metadata

        def destroy
          requires :name
          service.delete_server(name)
        end

        def image
          service.get_image(self.image_name.split('/')[-1])
        end

        def public_ip_address
          if self.network_interfaces.count
            self.network_interfaces[0]["networkIP"]
          else
            nil
          end
        end

        def ready?
          data = service.get_server(self.name, self.zone_name).body
          data['zone_name'] = self.zone_name
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
          service.servers.merge_attributes(data)
        end

        def setup(credentials = {})
          requires :public_ip_address, :public_key, :username
          service.set_metadata(self.instance, self.zone, {'sshKeys' => self.public_key })
        rescue Errno::ECONNREFUSED
          sleep(1)
          retry
        end

        def sshable?(options={})
          service.set_metadata(self.instance, self.zone, {'sshKeys' => self.public_key })
          ready? && !public_ip_address.nil? && public_key && metadata['sshKeys']
        rescue SystemCallError, Net::SSH::AuthenticationFailed, Timeout::Error
          false
        end

      end
    end
  end
end
