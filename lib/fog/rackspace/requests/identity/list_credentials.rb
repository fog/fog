module Fog
  module Rackspace
    class Identity
      class Real
        def list_credentials(user_id)
          response = request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "users/#{user_id}/OS-KSADM/credentials"
          )

          unless response.body['credentials'].is_a?(Array)
            response.body['credentials'] = [response.body['credential']]
            response.body.delete('credential')
          end

          response
        end
      end
    end
  end
end
