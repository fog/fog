require 'fog/compute/models/server'
require 'net/ssh/proxy/command'

module Fog
  module Compute
    class Google

      class Server < Fog::Compute::Server

        identity :name
        attribute :image_name, :aliases => 'image'
        attribute :network_interfaces, :aliases => 'networkInterfaces'
        attribute :network, :aliases => 'network'
        attribute :external_ip, :aliases => 'externalIP'
        attribute :state, :aliases => 'status'
        attribute :zone_name, :aliases => 'zone'
        attribute :machine_type, :aliases => 'machineType'
        attribute :disks, :aliases => 'disks'
        attribute :kernel, :aliases => 'kernel'
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
          if self.network_interfaces.respond_to? :each
            self.network_interfaces.each do |netif|
              if netif["accessConfigs"].respond_to? :each
                netif["accessConfigs"].each do |access_config|
                  if access_config["name"] == "External NAT"
                    ip = access_config['natIP']
                  end
                end
              end
            end
          end

          ip
        end

        def private_ip_address
          ip = nil
          if self.network_interfaces.respond_to? :first
            ip = self.network_interfaces.first['networkIP']
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

        def add_ssh_key username, key
          if self.metadata.nil?
            self.metadata = Hash.new("")
          end

          # You can have multiple SSH keys, seperated by newlines.
          # https://developers.google.com/compute/docs/console?hl=en#sshkeys
          if !self.metadata["sshKeys"].empty?
            self.metadata["sshKeys"] += "\n"
          end

          self.metadata["sshKeys"] += "#{username}:#{key.strip}"

          return self.metadata
        end


        def reload
          data = service.get_server(self.name, self.zone).body
          self.merge_attributes(data)
        end

        def save
          requires :name
          requires :machine_type
          requires :zone_name

          if not service.zones.include? self.zone_name
            raise ArgumentError.new "#{self.zone_name.inspect} is either down or you don't have permission to use it."
          end

          self.add_ssh_key(self.username, self.public_key) if self.public_key

          options = {
              'image' => image_name,
              'machineType' => machine_type,
              'networkInterfaces' => network_interfaces,
              'network' => network,
              'externalIp' => external_ip,
              'disks' => disks,
              'kernel' => kernel,
              'metadata' => metadata
          }.delete_if {|key, value| value.nil?}

          service.insert_server(name, zone_name, options)
          data = service.backoff_if_unfound {service.get_server(self.name, self.zone_name).body}

          service.servers.merge_attributes(data)
        end

      end
    end
  end
end
