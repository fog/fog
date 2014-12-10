module Fog
  module Compute
    class RackspaceV2
      class Real
        # Puts server into rescue mode
        # @param [String] server_id id of server to rescue
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::Errors::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::Errors::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::Errors::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::Errors::ServiceError]
        # @note Rescue mode is only guaranteed to be active for 90 minutes
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/rescue_mode.html
        #
        # * Status Transition:
        #   * PREP_RESCUE -> RESCUE
        #   * PREP_RESCUE -> ACTIVE (on error)
        def rescue_server(server_id)
          data = {
            'rescue' => nil
          }

          request(
            :body => Fog::JSON.encode(data),
            :expects => [200],
            :method => 'POST',
            :path => "servers/#{server_id}/action"
          )
        end
      end

      class Mock
        def rescue_server(server_id)
          server = self.data[:servers][server_id]
          server["status"] = "RESCUE"
          admin_pass = Fog::Mock.random_letters(12)
          server_response = { 'adminPass' => admin_pass }
          response(:status => 200, :body => server_response)
        end
      end
    end
  end
end
