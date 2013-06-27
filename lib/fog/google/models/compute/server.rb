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
          requires :name, :zone
          service.delete_server(name, zone)
        end

        def image
          service.get_image(self.image_name.split('/')[-1])
        end

        def public_ip_address
          ip = nil
          if self.network_interfaces
            self.network_interfaces.each do |netif|
              netif["accessConfigs"].each do |access_config|
                if access_config["name"] == "External NAT"
                  ip = access_config['natIP']
                end
              end
            end
          end

          ip
        end

        def metadata
          def []=(k,v)
            service.set_metadata(self.name, self.zone, {k => v})
            return self.metadata
          end
          data = service.get_server(self.name, self.zone).body
          data['metadata'] || {}
        end

        def ready?
          self.state == RUNNING
        end

        def zone
          if self.zone_name.is_a? String
            service.get_zone(self.zone_name.split('/')[-1]).body["name"]
          elsif zone_name.is_a? Excon::Response
            service.get_zone(zone_name.body["name"]).body["name"]
          else
            self.zone_name
          end
        end

        def reload
          data = service.get_server(self.name, self.zone).body
          self.merge_attributes(data)
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
        end

        def setup(credentials = {})
          requires :public_ip_address, :public_key, :username
          self.metadata['sshKeys'] = "#{self.username}:#{self.public_key}"
        rescue Errno::ECONNREFUSED
          sleep(1)
          retry
        end

      end
    end
  end
end
