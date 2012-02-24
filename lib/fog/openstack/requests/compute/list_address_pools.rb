module Fog
  module Compute
    class OpenStack
      class Real

        def list_address_pools
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "os-floating-ip-pools"
          )

        end

      end

      class Mock


      end
    end
  end
end
