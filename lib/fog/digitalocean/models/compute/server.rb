require 'fog/compute/models/server'

module Fog
  module Compute
    class DigitalOcean

      # A DigitalOcean Droplet
      #
      class Server < Fog::Compute::Server
        
        identity  :id
        attribute :name
       	attribute :state,	:aliases => 'status'
        attribute :image_id
        attribute :region_id
        attribute :flavor_id,         :aliases => 'size_id'
        # Not documented in their API, but
        # available nevertheless
        attribute :ip_address
        attribute :backups_active

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

        # Creates the server (not to be called directly).
        #
        # Usually called by Fog::Collection#create
        #
        #   do = Fog::Compute.new({
        #     :provider => 'DigitalOcean',
        #     :digitalocean_api_key   => 'key-here',      # your API key here
        #     :digitalocean_client_id => 'client-id-here' # your client key here
        #   })
        #   do.servers.create :name => 'foobar',
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
          end
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

      end

    end
  end
end
