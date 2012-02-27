module Fog
  module Identity
    class OpenStack
      class Real

        def delete_user_role(tenant_id, user_id, role_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}"
          )
        end

      end

      class Mock

      end
    end
  end
end

