module Fog
  module Compute
    class RackspaceV2
      class Real
        # Deletes virtual interface from server
        # @param [String] server_id The server id that contains the virtual interface
        # @param [String] interface_id The id of the virtual interface
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cn-devguide/content/delete_virt_interface_api.html
        def delete_virtual_interface(server_id, interface_id)
          request(
            :expects => [200],
            :method => 'DELETE',
            :path => "servers/#{server_id}/os-virtual-interfacesv2/#{interface_id}"
          )
        end
      end
    end
  end
end
