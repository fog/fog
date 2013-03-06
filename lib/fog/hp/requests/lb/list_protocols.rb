module Fog
  module HP
    class LB
      class Real
        def list_protocols
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'protocols'
          )
          response
        end
      end
      class Mock
        def list_protocols
          response = Excon::Response.new
          response.status = 200
          response.body   = {
            "protocols" => [
              { "name" => "HTTP", "port" => 80 },
              { "name" => "TCP", "port" => 443 }
            ]
          }

          response
        end
      end
    end
  end
end