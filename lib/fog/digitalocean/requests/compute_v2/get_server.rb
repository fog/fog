module Fog
  module Compute
    class DigitalOceanV2
      class Real
        def get_server(server_id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/v2/droplets/#{server_id}"
          )
        end
      end

      class Mock
        def get_server(server_id)
          response = Excon::Response.new
          response.status = 200

          server = self.data[:servers].find { |s| s['id'] == server_id }

          response.body = {
            "status" => "OK",
            "droplet"  => self.data[:servers].find { |s| s['id'] == server_id }
          }

          response
        end
      end
    end
  end
end
