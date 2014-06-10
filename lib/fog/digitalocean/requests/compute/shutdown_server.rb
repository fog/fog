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
          response = Excon::Response.new
          response.status = 200
          server = self.data[:servers].find { |s| s['id'] == id }

          # Simulate reboot
          server['status'] = 'off' if server

          response.body = {
            "event_id" => Fog::Mock.random_numbers(1).to_i,
            "status" => "OK"
          }
          response
        end
      end
    end
  end
end
