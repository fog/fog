module Fog
  module Compute
    class CloudAtCost
      class Real
        def list_templates
          request(
            :expects => [200],
            :method => 'GET',
            :path => '/api/v1/listtemplates.php'
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def list_templates
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
