module Fog
  module Compute
    class OpenStack
      class Real

        def allocate_ip(pool = nil)
          request(
            :body     => MultiJson.encode({'pool' => pool}),
            :expects  => [200, 202],
            :method   => 'POST',
            :path     => 'os-floating-ips'
          )
        end

      end

      class Mock

        def allocate_ip(server_id, ip)
          raise "Not implemented"
        end

      end
    end
  end
end
