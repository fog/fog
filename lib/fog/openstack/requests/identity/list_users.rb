module Fog
  module Identity
    class OpenStack
      class Real
        def list_users(tenant_id = nil)
          path = tenant_id ? "tenants/#{tenant_id}/users" : 'users'
          request(
            :expects => [200, 204],
            :method  => 'GET',
            :path    => path
          )
        end
      end # class Real

      class Mock
        def list_users(tenant_id = nil)
          Excon::Response.new(
            :body   => { 'users' => self.data[:users].values },
            :status => 200
          )
        end
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
