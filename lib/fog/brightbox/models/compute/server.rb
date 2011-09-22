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
        attribute :user_data
        attribute :console_url
        attribute :console_token

        # Times
        attribute :created_at, :type => :time
        attribute :started_at, :type => :time
        attribute :console_token_expires, :type => :time
        attribute :deleted_at, :type => :time

        # Links - to be replaced
        attribute :account_id,  :aliases => "account",      :squash => "id"
        attribute :image_id,    :aliases => "image",        :squash => "id"
        attribute :flavor_id,   :aliases => "server_type",  :squash => "id"
        attribute :zone_id,     :aliases => "zone",         :squash => "id"
        attribute :snapshots
        attribute :cloud_ips
        attribute :interfaces
        attribute :server_groups

        def initialize(attributes={})
          self.image_id   ||= 'img-2ab98' # Ubuntu Lucid 10.04 server (i686)
          super
        end

        def snapshot
          requires :identity
          connection.snapshot_server(identity)
        end

        def reboot
          false
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
          interfaces.first
        end

        def public_ip_address
          cloud_ips.first
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
      end
    end
  end
end
