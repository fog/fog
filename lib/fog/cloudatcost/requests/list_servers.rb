module Fog
  module Compute
    class CloudAtCost
      class Real
        def list_servers
          request(
            :expects => [200],
            :method => 'GET',
            :path => '/api/v1/listservers.php'
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def list_servers
          response = Excon::Response.new
          response.status = 200
          response.body = {
              'status' => 'OK',
              'servers'  => self.data[:data]
          }
          response
        end
      end
    end
  end
end
