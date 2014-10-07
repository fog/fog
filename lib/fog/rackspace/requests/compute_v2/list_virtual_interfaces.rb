module Fog
  module Compute
    class RackspaceV2
      class Real
        # Lists virtual interfaces for a server
        # @param [String] server_id
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cn-devguide/content/list_virt_interfaces.html
        def list_virtual_interfaces(server_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "servers/#{server_id}/os-virtual-interfacesv2"
          )
        end
      end
    end
  end
end
