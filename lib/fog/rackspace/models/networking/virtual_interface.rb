require 'fog/core/collection'
require 'fog/rackspace/models/networking/virtual_interface'

module Fog
  module Rackspace
    class Networking
      class VirtualInterface < Fog::Model
        # @!attribute [r] id
        # @return [String] The virtual interface id
        identity :id

        # @!attribute [r] mac_address
        # @return [String] The Media Access Control (MAC) address for the virtual interface.
        #   A MAC address is a unique identifier assigned to network interfaces for communications on the physical network segment.
        attribute :mac_address

        # @!attribute [r] ip_addresses
        # @return [Array<Hash>] returns an array of hashes containing information about allocated ip addresses and their associated networks
        # @example
        # [
        #   {
        #       "address": "2001:4800:7810:0512:d87b:9cbc:ff04:850c",
        #       "network_id": "ba122b32-dbcc-4c21-836e-b701996baeb3",
        #       "network_label": "public"
        #   },
        #   {
        #       "address": "64.49.226.149",
        #       "network_id": "ba122b32-dbcc-4c21-836e-b701996baeb3",
        #       "network_label": "public"
        #   }
        # ]
        attribute :ip_addresses

        # Saves the virtual interface.
        # This method can only create a virtual interface. Attempting to update interface will result an exception
        # @return [Boolean] true if virtual interface has been saved
        def save(attributes = {})
          if persisted?
            raise Fog::Errors::Error.new("This virtual interface has already been created and it cannot be updated")
          else
            create
          end
          true
        end

        # Creates Virtual interface for server
        # * requires attributes: :network
        # @return [Boolean] returns true if virtual network interface is being created
        # @raise [Fog::Rackspace::Networking::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Networking::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Networking::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Networking::ServiceError]
        # @example To create a virtual interface;
        # my_server.virtual_interfaces.create :network => my_network
        # @see http://docs.rackspace.com/servers/api/v2/cn-devguide/content/api_create_virtual_interface.html
        def create
          data = service.create_virtual_interface(server_id, network_id)
          merge_attributes(data.body['virtual_interfaces'].first)
        end

        # Destroy the virtual interface
        # @return [Boolean] returns true if virtual interface has been destroyed
        # @raise [Fog::Rackspace::Networking::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Networking::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Networking::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Networking::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cn-devguide/content/delete_virt_interface_api.html
        def destroy
          service.delete_virtual_interface(server_id, id)
          true
        end

        private

        def server_id
           attributes[:server].is_a?(Fog::Compute::RackspaceV2::Server) ? attributes[:server].id : attributes[:server]
        end

        def network_id
          attributes[:network].is_a?(Network) ? attributes[:network].id : attributes[:network]
        end
      end
    end
  end
end
