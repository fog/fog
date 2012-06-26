module Fog
  module Rackspace
    class Identity
      class Real
        def list_user_roles(user_id)
          response = request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "users/#{user_id}/roles"
          )

          if response.body.include? 'role'
            response.body['roles'] = [response.body['role']]
            response.body.delete('role')
          end

          response
        end
      end
    end
  end
end
