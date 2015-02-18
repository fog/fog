require 'fog/compute/models/server'
require 'net/ssh/proxy/command'

module Fog
  module Compute
    class Google
      class Server < Fog::Compute::Server
        identity :name

        attribute :kind
        attribute :id
        attribute :can_ip_forward, :aliases => 'canIpForward'
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description
        attribute :disks
        attribute :machine_type, :aliases => 'machineType'
        attribute :metadata
        attribute :network_interfaces, :aliases => 'networkInterfaces'
        attribute :scheduling
        attribute :self_link, :aliases => 'selfLink'
        attribute :service_accounts, :aliases => 'serviceAccounts'
        attribute :state, :aliases => 'status'
        attribute :status_message, :aliases => 'statusMessage'
        attribute :tags
        attribute :zone, :aliases => :zone_name

        # These attributes are not available in the representation of an 'instance' returned by the GCE API.
        # They are useful only for the create process
        attribute :network, :aliases => 'network'
        attribute :external_ip, :aliases => 'externalIP'
        attribute :auto_restart
        attribute :on_host_maintenance

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

        def destroy(async=true)
          requires :name, :zone

          data = service.delete_server(name, zone_name)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
          unless async
            operation.wait_for { ready? }
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

        def addresses
          [private_ip_address, public_ip_address]
        end

        def attach_disk(disk, options = {})
          requires :identity, :zone

          data = service.attach_disk(identity, zone_name, disk, options)
          Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
        end

        def detach_disk(device_name)
          requires :identity, :zone

          data = service.detach_disk(identity, zone, device_name)
          Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
        end

        def reboot
          requires :identity, :zone

          data = service.reset_server(identity, zone_name)
          Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
        end

        def start
          requires :identity, :zone

          data = service.start_server(identity, zone_name)
          Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
        end

        def stop
          requires :identity, :zone

          data = service.stop_server(identity, zone_name)
          Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
        end

        def serial_port_output
          requires :identity, :zone

          data = service.get_server_serial_port_output(identity, zone_name)
          data.body['contents']
        end

        def set_disk_auto_delete(auto_delete, device_name)
          requires :identity, :zone

          data = service.set_server_disk_auto_delete(identity, zone_name, auto_delete, device_name)
          Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
        end

        def set_scheduling(on_host_maintenance, automatic_restart)
          requires :identity, :zone

          data = service.set_server_scheduling(identity, zone_name, on_host_maintenance, automatic_restart)
          Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
        end

        def set_metadata(metadata = {})
          requires :identity, :zone

          data = service.set_metadata(identity, zone_name, self.metadata['fingerprint'], metadata)
          Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
        end

        def set_tags(tags = [])
          requires :identity, :zone

          data = service.set_tags(identity, zone_name, self.tags['fingerprint'], tags)
          Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
        end

        def ready?
          self.state == RUNNING
        end

        def zone_name
          zone.nil? ? nil : zone.split('/')[-1]
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
          data = service.get_server(self.name, zone_name).body
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
              'serviceAccounts' => service_accounts,
              'tags' => tags,
              'auto_restart' => auto_restart,
              'on_host_maintenance' => on_host_maintenance,
              'can_ip_forward' => can_ip_forward
          }.delete_if {|key, value| value.nil?}

          if service_accounts
            options['serviceAccounts'] = [{
              "kind" => "compute#serviceAccount",
              "email" => "default",
              "scopes" => service_accounts.map {
                |w| w.start_with?("https://") ? w : "https://www.googleapis.com/auth/#{w}"
              }
            }]
          end

          data = service.insert_server(name, zone_name, options)
          operation = Fog::Compute::Google::Operations.new(:service => service).get(data.body['name'], data.body['zone'])
          operation.wait_for { !pending? }
          reload
        end
      end
    end
  end
end
