module Fog
  module Compute
    class OpenStack
      class Real

        def release_address(address_id)
          request(
            :expects => [200, 202],
            :method => 'DELETE',
            :path   => "os-floating-ips/#{address_id}"
          )
        end

      end

      class Mock


      end
    end
  end
end
