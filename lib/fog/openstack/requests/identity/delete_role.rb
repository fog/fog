module Fog
  module Identity
    class OpenStack
      class Real

        def delete_role(role_id)
          request(
            :expects => [200, 204],
            :method => 'DELETE',
            :path   => '/OS-KSADM/roles/%s' % role_id
          )
        end

      end

      class Mock

        def delete_role(role_id)
          response = Excon::Response.new
          if role = list_roles.body['roles'].detect {|_| _['id'] == role_id}
            self.data[:roles].delete(role_id)
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
