module Fog
  module Identity
    class OpenStack
      class Real
        def add_user_to_tenant(tenant_id, user_id, role_id)
          request(
            :expects => 200,
            :method  => 'PUT',
            :path    => "/tenants/#{tenant_id}/users/#{user_id}/roles/OS-KSADM/#{role_id}"
          )
        end
      end # class Real

      class Mock
        def add_user_to_tenant(tenant_id, user_id, role_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'role' => {
              'id' => '503df61a99d6461fb247cdb6a3f3a4dd',
              'name' => 'admin'
            }
          }
          response
        end # def add_user_to_tenant
      end # class Mock
    end # class OpenStack
  end # module Identity
end
