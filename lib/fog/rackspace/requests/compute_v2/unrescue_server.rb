module Fog
  module Compute
    class RackspaceV2
      class Real
        # Take server out of rescue mode
        # @param [String] server_id id of server
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Errors::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Errors::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Errors::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Errors::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/exit_rescue_mode.html
        #
        # * Status Transition:
        #   * RESCUE -> PREP_UNRESCUE -> ACTIVE
        #   * RESCUE -> ERROR (on error)
        def unrescue_server(server_id)
          data = {
            'unrescue' => nil
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
        def unrescue_server(server_id)
          server = self.data[:servers][server_id]
          server["status"] = "ACTIVE"
          response(:status => 202)
        end
      end
    end
  end
end
