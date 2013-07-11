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

          if self.metadata.nil?
            self.metadata = {}
          end

          self.metadata.merge!({
            "sshKeys" => "#{username}:#{File.read(public_key_path).strip}"
          }) if :public_key_path

          data = service.insert_server(
            self.name,
            self.image_name,
            self.zone_name,
            self.machine_type,
            self.metadata)
        end

      end
    end
  end
end
