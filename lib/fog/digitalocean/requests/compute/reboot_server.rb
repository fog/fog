module Fog
  module Compute
    class DigitalOcean
      class Real

        def reboot_server( id )
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "droplets/#{id}/reboot"
          )
        end

      end

      class Mock

        def reboot_server( id )
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
