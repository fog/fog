module Fog
  module Rackspace
    class Networking
      class Real
        # Lists virtual interfaces for a server
        # @param [String] server_id
        # @raise [Fog::Rackspace::Networking::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Networking::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Networking::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Networking::ServiceError]
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
