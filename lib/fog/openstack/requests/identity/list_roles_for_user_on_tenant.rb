module Fog
  module Identity
    class OpenStack
      class Real
        def list_roles_for_user_on_tenant(tenant_id, user_id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "tenants/#{tenant_id}/users/#{user_id}/roles"
          )
        end # def list_roles_for_user_on_tenant
      end # class Real

      class Mock
        def list_roles_for_user_on_tenant(tenant_id, user_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'roles' => [
              {'id' => '1',
               'name' => 'admin'}
            ]
          }
          response
        end # def list_roles_for_user_on_tenant
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
