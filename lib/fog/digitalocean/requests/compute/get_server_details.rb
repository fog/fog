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
