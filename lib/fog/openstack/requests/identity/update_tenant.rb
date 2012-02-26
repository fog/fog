module Fog
  module Identity
    class OpenStack
      class Real
        def update_tenant(id, attributes)
          request(
            :expects => [200],
            :method  => 'PUT',
            :path    => "tenants/#{id}",
            :body    => {
              'tenant' => attributes
            }.to_json
          )
        end # def create_tenant
      end # class Real

      class Mock
        def update_tenant(id, attributes)
          response = Excon::Response.new
          response.status = [200, 204][rand(1)]
          attributes = {'enabled' => true, 'id' => '1'}.merge(attributes)
          response.body = {
            'tenant' => attributes
          }
          response
        end # def create_tenant
      end # class Mock
    end # class OpenStack
  end # module Identity
end # module Fog
