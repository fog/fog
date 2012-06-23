module Fog
  module Rackspace
    class Identity
      class Real
        def list_tenants()
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => 'tenants'
          )
        end
      end
    end
  end
end
