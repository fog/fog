module Fog
  module Compute
    class OpenStack
      class Real

        def get_address(address_id)

          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "os-floating-ips/#{address_id}"
          )
        end

      end

      class Mock



      end
    end
  end
end
