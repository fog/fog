module Fog
  module Compute
    class RackspaceV2
      class Real
        # Creates virtual interface for a server
        # @param [String] server_id The server id to create the virtual interface on
        # @param [String] network_id The network id to attach the virtual interface to
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
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
