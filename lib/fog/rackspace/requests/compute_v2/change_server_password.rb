module Fog
  module Compute
    class RackspaceV2
      class Real
        # Changes server admin password
        # @param [String] server_id
        # @param [String] password
        # @return [Excon::Response] response
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @note Though Rackspace does not enforce complexity requirements for the password, the operating system might. If the password is not complex enough, the server might enter an ERROR state.
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Change_Password-d1e3234.html
        def change_server_password(server_id, password)
          data = {
            'changePassword' => {
              'adminPass' => password
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
        def change_server_password(server_id, password)
          response(:status => 202)
        end
      end
    end
  end
end
