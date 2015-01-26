module Fog
  module Compute
    class DigitalOcean
      class Real
        def list_servers(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'droplets'
          )
        end
      end

      class Mock
        def list_servers
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "OK",
            "droplets"  => self.data[:servers]
          }
          response
        end
      end
    end
  end
end
