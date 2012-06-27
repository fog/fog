module Fog
  module Rackspace
    class Identity
      class Real
        def list_users()
          response = request(
            :expects => [200, 203],
            :method => 'GET',
            :path => 'users'
          )

          unless response.body['users'].is_a?(Array)
            response.body['users'] = [response.body['user']]
            response.body.delete('user')
          end

          response
        end
      end
    end
  end
end
