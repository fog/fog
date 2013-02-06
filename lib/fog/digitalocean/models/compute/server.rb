require 'fog/compute/models/server'

module Fog
  module Compute
    class DigitalOcean

      # A DigitalOcean Droplet
      #
      class Server < Fog::Compute::Server
        
        identity  :id
        attribute :name
        attribute :status
        attribute :image_id
        attribute :region_id
        attribute :flavor_id,         :aliases => :size_id
        attribute :backups_active

        # Reboot the server (soft reboot).
        #
        # The preferred method of rebooting a server.
        def reboot
          service.reboot_server id
        end

        # Reboot the server (hard reboot).
        #
        # Powers the server off and then powers it on again.
        def power_cycle
          raise NotImplementedError
        end

        # Shutdown the server
        #
        # Sends a shutdown signal to the operating system.
        # The server consumes resources while powered off
        # so you are still charged.
        #
        # @see https://www.digitalocean.com/community/questions/am-i-charged-while-my-droplet-is-in-a-powered-off-state
        def shutdown
          raise NotImplementedError
        end

        # Power off the server
        #
        # Works as a power switch.
        # The server consumes resources while powered off
        # so you are still charged.
        # 
        # Server.power_off is an alias to Server.stop
        #
        # @see https://www.digitalocean.com/community/questions/am-i-charged-while-my-droplet-is-in-a-powered-off-state
        def stop
          raise NotImplementedError
        end
        alias power_off stop

        # Power on the server.
        #
        # The server consumes resources while powered on
        # so you will be charged.
        #
        # Each time a server is spun up, even if for a few seconds, 
        # it is charged for an hour.
        #
        # Server.power_off is an alias to Server.stop
        #
        def start
          raise NotImplementedError
        end
        alias power_on start

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
          meta_hash = {}
          options = {
            'name'        => name,
            'size_id'     => flavor_id,
            'image_id'    => image_id,
            'region_id'   => region_id,
          }
          data = service.create_server name, flavor_id, image_id, region_id
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
          status == 'active'
        end

      end

    end
  end
end
