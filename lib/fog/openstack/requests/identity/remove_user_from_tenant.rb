module Fog
  module Identity
    class OpenStack
      class Real
        def remove_user_from_tenant(tenant_id, user_id, role_id)
          request(
            :expects => [200, 204],
            :method  => 'DELETE',
            :path    => "/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}"
          )
        end
      end # class Real

      class Mock
        def remove_user_from_tenant(tenant_id, user_id, role_id)
        end # def remove_user_from_tenant
      end # class Mock
    end # class OpenStack
  end # module Identity
end
