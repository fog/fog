module Fog
  module Compute
    class RackspaceV2
      class Real

        # Reverts server resize operation
        # @param [String] server_id id of server to resize
        # @param [String] flavor_id id of the desired flavor
        # @return [Excon::Response] response
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @note All resizes are automatically confirmed after 24 hours if you do not explicitly confirm or revert the resize.                
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Revert_Resized_Server-d1e4024.html
        #
        # * Status Transition:
        #   * VERIFY_RESIZE -> ACTIVE
        #   * VERIFY_RESIZE -> ERROR (on error)        
        def resize_server(server_id, flavor_id)
          data = {
            'resize' => {
              'flavorRef' => flavor_id
            }
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => [202],
            :method => 'POST',
            :path => "servers/#{server_id}/action"
          )
        end
      end

      class Mock
        def resize_server(server_id, flavor_id)
          server = self.data[:servers][server_id]
          server["status"] = "VERIFY_RESIZE"
          response(:status => 202)
        end
      end
    end
  end
end
