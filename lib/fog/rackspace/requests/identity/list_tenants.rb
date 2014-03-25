module Fog
  module Rackspace
    class Identity
      class Real
        def list_tenants()
          response = request(
            :expects => [200, 203],
            :method => 'GET',
            :path => 'tenants'
          )

          unless response.body['tenants'].is_a?(Array)
            response.body['tenants'] = [response.body['tenant']]
            response.body.delete('tenant')
          end

          response
        end
      end

      class Mock
        def list_tenants
          response = Excon::Response.new
          response.status = [200, 203][rand(1)]
          response.body = {
            "tenants" => [
              {
                "id" => Fog::Mock.random_numbers(6),
                "name" => "Enabled tenant",
                "enabled" => true
              },
              {
                "id" => Fog::Mock.random_numbers(6),
                "name" => "Disabled tenant",
                "enabled" => false
              },
            ],
            "tenants_links" => []
          }
          response
        end
      end
    end
  end
end
