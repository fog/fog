module Fog
  module Compute
    class OpenStack
      class Real

        def deallocate_ip(ip)
          request(
            :expects  => [200, 202],
            :method   => 'DELETE',
            :path     => 'os-floating-ips/' + ip.id.to_s
          )
        end

      end

      class Mock

        def deallocate_ip(ip)
          raise "Not implemented"
        end

      end
    end
  end
end
