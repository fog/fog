module Fog
  module Compute
    class OpenStack
      class Real
        def remove_flavor_access(flavor_ref, tenant_id)
          request(
            :body => MultiJson.encode({
              "removeTenantAccess" => {
                "tenant" => tenant_id
              }
            }),
            :expects  => [200, 203],
            :method   => 'POST',
            :path     => "flavors/#{flavor_ref}/action.json"
          )
        end
      end

      class Mock
        def remove_flavor_access(flavor_ref, tenant_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "flavor_access" => []
          }
          response
        end
      end
    end
  end
end
