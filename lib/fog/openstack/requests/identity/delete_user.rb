module Fog
  module Identity
    class OpenStack
      class Real

        def delete_user(user_id)
          request(
            :expects => 200,
            :method => 'DELETE',
            :path   => "users/#{user_id}"
          )
        end

      end

      class Mock

        def delete_user(user_id)
          response = Excon::Response.new
          if user = list_users.body['users'][user_id]
            self.data[:users].delete(user_id)
            response.status = 204
            response
          else
            raise Fog::Identity::OpenStack::NotFound
          end
        end

      end
    end
  end
end
