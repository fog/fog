require 'fog/compute/models/server'
require 'net/ssh/proxy/command'

module Fog
  module Compute
    class Google

      class Server < Fog::Compute::Server

        identity :name

        attribute :network_interfaces, :aliases => 'networkInterfaces'
        attribute :network, :aliases => 'network'
        attribute :external_ip, :aliases => 'externalIP'
        attribute :state, :aliases => 'status'
        attribute :zone_name, :aliases => 'zone'
        attribute :machine_type, :aliases => 'machineType'
        attribute :disks, :aliases => 'disks'
        attribute :metadata
        attribute :tags, :squash => 'items'
        attribute :self_link, :aliases => 'selfLink'

        def image_name=(args)
          Fog::Logger.deprecation("image_name= is no longer used [light_black](#{caller.first})[/]")
        end

        def image_name
          boot_disk = disks.first
          unless boot_disk.is_a?(Disk)
            source = boot_disk['source']
            match = source.match(%r{/zones/(.*)/disks/(.*)$})
            boot_disk = service.disks.get match[2], match[1]
          end
          boot_disk.source_image.nil? ? nil : boot_disk.source_image
        end

        def kernel=(args)
          Fog::Logger.deprecation("kernel= is no longer used [light_black](#{caller.first})[/]")
        end
        def kernel
          Fog::Logger.deprecation("kernel is no longer used [light_black](#{caller.first})[/]")
          nil
        end

        def flavor_id
          machine_type
        end

        def flavor_id=(flavor_id)
          machine_type=flavor_id
        end

        def destroy
          requires :name, :zone
          operation = service.delete_server(name, zone)
          # wait until "RUNNING" or "DONE" to ensure the operation doesn't fail, raises exception on error
          Fog.wait_for do
            operation = service.get_zone_operation(zone_name, operation.body["name"])
            operation.body["status"] != "PENDING"
          end
          operation
        end

        # not used since v1
        def image
          Fog::Logger.deprecation("Server.image is deprecated, get source_image from boot disk")
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
          if !self.metadata["sshKeys"]
            self.metadata["sshKeys"] = ""
          end

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
          requires :disks

          if not service.zones.find{ |zone| zone.name == self.zone_name }
            raise ArgumentError.new "#{self.zone_name.inspect} is either down or you don't have permission to use it."
          end

          self.add_ssh_key(self.username, self.public_key) if self.public_key

          options = {
              'machineType' => machine_type,
              'networkInterfaces' => network_interfaces,
              'network' => network,
              'externalIp' => external_ip,
              'disks' => disks,
              'metadata' => metadata,
              'tags' => tags
          }.delete_if {|key, value| value.nil?}

          service.insert_server(name, zone_name, options)
          data = service.backoff_if_unfound {service.get_server(self.name, self.zone_name).body}

          service.servers.merge_attributes(data)
        end

      end
    end
  end
end
