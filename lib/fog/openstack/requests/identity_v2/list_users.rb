module Fog
  module Identity
    class OpenStack
      class V2
        class Real
          def list_users(options = {})
            if options.is_a?(Hash)
              tenant_id = options.delete(:tenant_id)
              query = options
            else
              Fog::Logger.deprecation('Calling OpenStack[:identity].list_users(tenant_id) is deprecated, use .list_users(:tenant_id => value)')
              tenant_id = options
              query = {}
            end

            path = tenant_id ? "tenants/#{tenant_id}/users" : 'users'
            request(
                :expects => [200, 204],
                :method  => 'GET',
                :path    => path,
                :query   => query
            )
          end
        end # class Real

        class Mock
          def list_users(options = {})
            tenant_id = options[:tenant_id]

            users = self.data[:users].values

            if tenant_id
              users = users.select {
                  |user| user['tenantId'] == tenant_id
              }
            end

            Excon::Response.new(
                :body => {'users' => users},
                :status => 200
            )
          end
        end # class Mock
      end # class V2
    end # class OpenStack
  end # module Identity
end # module Fog
