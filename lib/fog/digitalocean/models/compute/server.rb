require 'fog/compute/models/server'

module Fog
  module Compute
    class DigitalOcean
      # A DigitalOcean Droplet
      #
      class Server < Fog::Compute::Server
        identity  :id
        attribute :name
        attribute :state, :aliases => 'status'
        attribute :image_id
        attribute :region_id
        attribute :flavor_id, :aliases => 'size_id'
        attribute :public_ip_address, :aliases => 'ip_address'
        attribute :private_ip_address
        attribute :private_networking
        attribute :backups_active, :aliases => 'backups_enabled'
        attribute :created_at

        attr_writer :ssh_keys

        # Deprecated: Use public_ip_address instead.
        def ip_address
          Fog::Logger.warning("ip_address has been deprecated. Use public_ip_address instead")
          public_ip_address
        end

        # Reboot the server (soft reboot).
        #
        # The preferred method of rebooting a server.
        def reboot
          requires :id
          service.reboot_server self.id
        end

        # Reboot the server (hard reboot).
        #
        # Powers the server off and then powers it on again.
        def power_cycle
          requires :id
          service.power_cycle_server self.id
        end

        # Shutdown the server
        #
        # Sends a shutdown signal to the operating system.
        # The server consumes resources while powered off
        # so you are still charged.
        #
        # @see https://www.digitalocean.com/community/questions/am-i-charged-while-my-droplet-is-in-a-powered-off-state
        def shutdown
          requires :id
          service.shutdown_server self.id
        end

        # Power off the server
        #
        # Works as a power switch.
        # The server consumes resources while powered off
        # so you are still charged.
        #
        # @see https://www.digitalocean.com/community/questions/am-i-charged-while-my-droplet-is-in-a-powered-off-state
        def stop
          requires :id
          service.power_off_server self.id
        end

        # Power on the server.
        #
        # The server consumes resources while powered on
        # so you will be charged.
        #
        # Each time a server is spun up, even if for a few seconds,
        # it is charged for an hour.
        #
        def start
          requires :id
          service.power_on_server self.id
        end

        def setup(credentials = {})
          requires :ssh_ip_address

          commands = [
            %{mkdir .ssh},
            %{passwd -l #{username}},
            %{echo "#{Fog::JSON.encode(Fog::JSON.sanitize(attributes))}" >> ~/attributes.json}
          ]
          if public_key
            commands << %{echo "#{public_key}" >> ~/.ssh/authorized_keys}
          end

          # wait for DigitalOcean to be ready
          wait_for { sshable?(credentials) }

          Fog::SSH.new(ssh_ip_address, username, credentials).run(commands)
        end

        # Creates the server (not to be called directly).
        #
        # Usually called by Fog::Collection#create
        #
        #   docean = Fog::Compute.new({
        #     :provider => 'DigitalOcean',
        #     :digitalocean_api_key   => 'key-here',      # your API key here
        #     :digitalocean_client_id => 'client-id-here' # your client key here
        #   })
        #   docean.servers.create :name => 'foobar',
        #                     :image_id  => image_id_here,
        #                     :flavor_id => flavor_id_here,
        #                     :region_id => region_id_here
        #
        # @return [Boolean]
        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :name, :flavor_id, :image_id, :region_id

          options = {}
          if attributes[:ssh_key_ids]
            options[:ssh_key_ids] = attributes[:ssh_key_ids]
          elsif @ssh_keys
            options[:ssh_key_ids] = @ssh_keys.map(&:id)
          end

          options[:private_networking] = private_networking
          options[:backups_active] =  backups_active

          data = service.create_server name,
                                       flavor_id,
                                       image_id,
                                       region_id,
                                       options
          merge_attributes(data.body['droplet'])
          true
        end

        # Destroy the server, freeing up the resources.
        #
        # DigitalOcean will stop charging you for the resources
        # the server was using.
        #
        # Once the server has been destroyed, there's no way
        # to recover it so the data is irrecoverably lost.
        #
        # IMPORTANT: As of 2013/01/31, you should wait some time to
        # destroy the server after creating it. If you try to destroy
        # the server too fast, the destroy event may be lost and the
        # server will remain running and consuming resources, so
        # DigitalOcean will keep charging you.
        # Double checked this with DigitalOcean staff and confirmed
        # that it's the way it works right now.
        #
        # Double check the server has been destroyed!
        def destroy
          requires :id
          service.destroy_server id
        end

        # Checks whether the server status is 'active'.
        #
        # The server transitions from 'new' to 'active' sixty to ninety
        # seconds after creating it (time varies and may take more
        # than 90 secs).
        #
        # @return [Boolean]
        def ready?
          state == 'active'
        end

        # DigitalOcean API does not support updating server state
        def update
          msg = 'DigitalOcean servers do not support updates'
          raise NotImplementedError.new(msg)
        end

        # Helper method to get the flavor name
        def flavor
          requires :flavor_id
          @flavor ||= service.flavors.get(flavor_id.to_i)
        end

        # Helper method to get the image name
        def image
          requires :image_id
          @image ||= service.images.get(image_id.to_i)
        end

        # Helper method to get the region name
        def region
          requires :region_id
          @region ||= service.regions.get(region_id.to_i)
        end

        # Helper method to get an array with all available IP addresses
        def ip_addresses
          [public_ip_address, private_ip_address].flatten.select(&:present?)
        end
      end
    end
  end
end
