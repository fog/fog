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
          response = Excon::Response.new
          response.status = 200
          server = self.data[:servers].find { |s| s['id'] == id }
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
