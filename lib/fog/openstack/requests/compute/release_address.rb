module Fog
  module Compute
    class Openstack
      class Real

        def release_address(address_id)
          request(
            :expects => 202,
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
