module Fog
  module Compute
    class DigitalOcean
      class Real

        def power_on_server( id )
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "droplets/#{id}/power_on"
          )
        end

      end

      class Mock

        def power_on_server( id )
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
