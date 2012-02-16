module Fog
  module Compute
    class Openstack
      class Real

        def allocate_address

          request(
            :body     => nil,
            :expects  => 200,
            :method   => 'POST',
            :path     => 'os-floating-ips.json'
          )
        end

      end

      class Mock



      end
    end
  end
end
