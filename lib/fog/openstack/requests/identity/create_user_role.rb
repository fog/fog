module Fog
  module Identity
    class OpenStack
      class Real

        def create_user_role(tenant_id, user_id, role_id)
          request(
            :expects  => 200,
            :method   => 'PUT',
            :path     => "/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}"
          )
        end

      end

      class Mock
        def create_user_role(tenant_id, user_id, role_id)
          response = Excon::Response.new
          response.status = 200
          response
        end
      end
    end
  end
end
