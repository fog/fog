require 'fog/compute/models/server'

module Fog
  module Compute
    class Brightbox

      class Server < Fog::Compute::Server

        identity  :id
        attribute :resource_type
        attribute :url

        attribute :name
        attribute :state,       :aliases => 'status'

        attribute :hostname
        attribute :fqdn
        attribute :user_data
        attribute :console_url
        attribute :fqdn
        attribute :console_token

        # Times
        attribute :created_at, :type => :time
        attribute :started_at, :type => :time
        attribute :console_token_expires, :type => :time
        attribute :deleted_at, :type => :time

        # Links - to be replaced
        attribute :account_id,  :aliases => "account",      :squash => "id"
        attribute :image_id,    :aliases => "image",        :squash => "id"

        attribute :snapshots
        attribute :cloud_ips
        attribute :interfaces
        attribute :server_groups
        attribute :zone
        attribute :server_type

        def initialize(attributes = {})
          # Call super first to initialize the service object for our default image
          super
          self.image_id ||= service.default_image
        end

        def zone_id
          if t_zone_id = attributes[:zone_id]
            t_zone_id
          elsif zone
            zone[:id] || zone['id']
          end
        end

        def flavor_id
          if t_flavour_id = attributes[:flavor_id]
            t_flavour_id
          elsif server_type
            server_type[:id] || server_type['id']
          end
        end

        def zone_id=(incoming_zone_id)
          attributes[:zone_id] = incoming_zone_id
        end

        def flavor_id=(incoming_flavour_id)
          attributes[:flavor_id] = incoming_flavour_id
        end

        def snapshot
          requires :identity
          service.snapshot_server(identity)
        end

        # Directly requesting a server reboot is not supported in the API
        # so needs to attempt a shutdown/stop, wait and start again.
        #
        # Default behaviour is a hard reboot because it is more reliable
        # because the state of the server's OS is irrelevant.
        #
        # @param [Boolean] use_hard_reboot
        # @return [Boolean]
        def reboot(use_hard_reboot = true)
          requires :identity
          if ready?
            if use_hard_reboot
              hard_reboot
            else
              soft_reboot
            end
          else
            # Not able to reboot if not ready in the first place
            false
          end
        end

        def start
          requires :identity
          service.start_server(identity)
          true
        end

        def stop
          requires :identity
          service.stop_server(identity)
          true
        end

        def shutdown
          requires :identity
          service.shutdown_server(identity)
          true
        end

        def destroy
          requires :identity
          service.destroy_server(identity)
          true
        end

        def flavor
          requires :flavor_id
          service.flavors.get(flavor_id)
        end

        def image
          requires :image_id
          service.images.get(image_id)
        end

        # Returns the public DNS name of the server
        #
        # @return [String]
        #
        def dns_name
          ["public", fqdn].join(".")
        end

        def private_ip_address
          if interfaces.empty?
            nil
          else
            interfaces.first["ipv4_address"]
          end
        end

        def public_ip_address
          if cloud_ips.empty?
            nil
          else
            cloud_ips.first["public_ip"]
          end
        end

        def ready?
          state == "active"
        end

        def activate_console
          requires :identity
          response = service.activate_console_server(identity)
          [response["console_url"], response["console_token"], response["console_token_expires"]]
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :image_id
          options = {
            :image => image_id,
            :name => name,
            :zone => zone_id,
            :user_data => user_data,
            :server_groups => server_groups
          }.delete_if { |k, v| v.nil? || v == "" }

          options.merge!(:server_type => flavor_id) unless flavor_id.nil? || flavor_id == ""

          data = service.create_server(options)
          merge_attributes(data)
          true
        end

        # Replaces the server's identifier with it's interface's identifier for Cloud IP mapping
        #
        # @return [String] the identifier to pass to a Cloud IP mapping request
        def mapping_identity
          interfaces.first["id"]
        end

        private

        # Hard reboots are fast, avoiding the OS by doing a "power off"
        def hard_reboot
          stop
          wait_for { !ready? }
          start
        end

        # Soft reboots often timeout if the OS missed the request so we do more
        # error checking trying to detect the timeout
        #
        # @todo Needs cleaner error handling when the OS times out
        def soft_reboot
          shutdown
          # FIXME: Using side effect of wait_for's (evaluated block) to detect timeouts
          begin
            wait_for(20) { !ready? }
            start
          rescue Fog::Errors::Timeout
            false
          end
        end
      end

    end
  end
end
