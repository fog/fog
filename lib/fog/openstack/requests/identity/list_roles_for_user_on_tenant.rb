module Fog
  module Identity
    class Openstack
      class Real

        def list_roles_for_user_on_tenant(tenant_id, user_id)
          
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "tenants/#{tenant_id}/users/#{user_id}/roles"
          )
        end

      end

      class Mock



      end
    end
  end
end
