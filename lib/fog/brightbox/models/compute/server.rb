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

        def initialize(attributes={})
          self.image_id ||= Fog::Compute[:brightbox].default_image
          super
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
          connection.snapshot_server(identity)
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
            unless use_hard_reboot
              soft_reboot
            else
              hard_reboot
            end
          else
            # Not able to reboot if not ready in the first place
            false
          end
        end

        def start
          requires :identity
          connection.start_server(identity)
          true
        end

        def stop
          requires :identity
          connection.stop_server(identity)
          true
        end

        def shutdown
          requires :identity
          connection.shutdown_server(identity)
          true
        end

        def destroy
          requires :identity
          connection.destroy_server(identity)
          true
        end

        def flavor
          requires :flavor_id
          connection.flavors.get(flavor_id)
        end

        def image
          requires :image_id
          connection.images.get(image_id)
        end

        def private_ip_address
          unless interfaces.empty?
            interfaces.first["ipv4_address"]
          else
            nil
          end
        end

        def public_ip_address
          unless cloud_ips.empty?
            cloud_ips.first["public_ip"]
          else
            nil
          end
        end

        def ready?
          self.state == 'active'
        end

        def activate_console
          requires :identity
          response = connection.activate_console_server(identity)
          [response["console_url"], response["console_token"], response["console_token_expires"]]
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :image_id
          options = {
            :image => image_id,
            :name => name,
            :zone => zone_id,
            :user_data => user_data,
            :server_groups => server_groups
          }.delete_if {|k,v| v.nil? || v == "" }
          unless flavor_id.nil? || flavor_id == ""
            options.merge!(:server_type => flavor_id)
          end
          data = connection.create_server(options)
          merge_attributes(data)
          true
        end

      private
        # Hard reboots are fast, avoiding the OS by doing a "power off"
        def hard_reboot
          stop
          wait_for { ! ready? }
          start
        end

        # Soft reboots often timeout if the OS missed the request so we do more
        # error checking trying to detect the timeout
        #
        # @fixme - Using side effect of wait_for's (evaluated block) to detect timeouts
        def soft_reboot
          shutdown
          if wait_for(20) { ! ready? }
            # Server is now down, start it up again
            start
          else
            # We timed out
            false
          end
        end
      end

    end
  end
end
