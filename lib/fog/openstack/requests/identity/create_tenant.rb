module Fog
  module Identity
    class OpenStack
      class Real
        def create_tenant(attributes)
          request(
            :expects => [200],
            :method  => 'POST',
            :path    => "tenants",
            :body    => {
              'tenant' => attributes
            }.to_json
          )
        end # def create_tenant
      end # class Real

      class Mock
        def create_tenant(attributes)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          response.body = {
            'tenant' => {
              'id' => "df9a815161eba9b76cc748fd5c5af73e",
              'description' => attributes['description'] || 'normal tenant',
              'enabled' => true,
              'name' => attributes['name'] || 'default'
            }
          }
          response
        end # def create_tenant
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
