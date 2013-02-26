module Fog
  module Compute
    class DigitalOcean
      class Real

        def shutdown_server( id )
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "droplets/#{id}/shutdown"
          )
        end

      end

      class Mock

        def shutdown_server( id )
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
