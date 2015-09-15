module Fog
  module Compute
    class DigitalOceanV2
      class Real
        def list_servers
          request(
            :expects => [200],
            :method => 'GET',
            :path => '/v2/droplets'
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
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