module Fog
  module Compute
    class OpenStack
      class Real

        def list_ips
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'os-floating-ips'
          )
        end

      end

      class Mock

        def list_ips
          raise "Not implemented"
        end

      end
    end
  end
end
