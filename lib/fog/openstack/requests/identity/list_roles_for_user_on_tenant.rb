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
          Excon::Response.new(
            :body   => { 'roles' => self.data[:roles].values },
            :status => 200
          )
        end # def list_roles_for_user_on_tenant
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
