require 'fog/core/model'

module Fog
  module Compute
    class Brightbox

      class CloudIp < Fog::Model

        identity :id
        attribute :url
        attribute :resource_type

        attribute :name
        attribute :status
        attribute :description

        attribute :reverse_dns
        attribute :public_ip

        # Links - to be replaced
        attribute :account_id, :aliases => "account", :squash => "id"
        attribute :interface_id, :aliases => "interface", :squash => "id"
        attribute :server_id, :aliases => "server", :squash => "id"
        attribute :load_balancer, :alias => "load_balancer", :squash => "id"
        attribute :server_group, :alias => "server_group", :squash => "id"
        attribute :database_server, :alias => "database_server", :squash => "id"
        attribute :port_translators
        attribute :name

        # Attempt to map or point the Cloud IP to the destination resource.
        #
        # @param [Object] destination
        #
        def map(destination)
          requires :identity
          if destination.respond_to?(:mapping_identity)
            final_destination = destination.mapping_identity
          elsif destination.respond_to?(:identity)
            final_destination = destination.identity
          else
            final_destination = destination
          end
          service.map_cloud_ip(identity, :destination => final_destination)
        end

        def mapped?
          status == "mapped"
        end

        def unmap
          requires :identity
          service.unmap_cloud_ip(identity)
        end

        def destroy
          requires :identity
          service.destroy_cloud_ip(identity)
        end

        def destination_id
          server_id || load_balancer || server_group || database_server || interface_id
        end

      end

    end
  end
end
