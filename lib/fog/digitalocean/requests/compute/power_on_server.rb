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
          response = Excon::Response.new
          response.status = 200
          server = self.data[:servers].find { |s| s['id'] }
          server['status'] = 'active' if server
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
