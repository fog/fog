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
          response = Excon::Response.new
          response.status = 200
          response.body = { 'users' => self.data[:users].values }
          response
        end
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
