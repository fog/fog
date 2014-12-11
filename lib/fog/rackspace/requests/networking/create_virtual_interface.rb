module Fog
  module Rackspace
    class Networking
      class Real
        # Creates virtual interface for a server
        # @param [String] server_id The server id to create the virtual interface on
        # @param [String] network_id The network id to attach the virtual interface to
        # @raise [Fog::Rackspace::Networking::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Networking::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Networking::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Networking::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cn-devguide/content/api_create_virtual_interface.html
        def create_virtual_interface(server_id, network_id)
          data = {
            :virtual_interface => {
              :network_id => network_id
            }
          }

          request(
            :expects => [200],
            :method => 'POST',
            :path => "servers/#{server_id}/os-virtual-interfacesv2",
            :body => Fog::JSON.encode(data)
          )
        end
      end
    end
  end
end
