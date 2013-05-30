module Fog
  module Compute
    class OpenStack
      class Real
        def list_tenants_with_flavor_access(flavor_ref)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "flavors/#{flavor_ref}/os-flavor-access.json"
          )
        end
      end

      class Mock
        def list_tenants_with_flavor_access(flavor_ref)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "flavor_access" => [{ "tenant_id" => @tenant_id, "flavor_id" => flavor_ref }]
          }
          response
        end
      end
    end
  end
end
