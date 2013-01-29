module Fog
  module Compute
    class DigitalOcean
      class Real

        def get_server_details(server_id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "droplets/#{server_id}"
          )
        end

      end

      class Mock

        def get_server_details(server_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
