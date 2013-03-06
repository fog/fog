module Fog
  module HP
    class LB
      class Real
        def list_algorithms
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'algorithms'
          )
          response
        end
      end
      class Mock
        def list_algorithms
          response = Excon::Response.new
          response.status = 200
          response.body = { "algorithms" => [
              { "name" => "ROUND_ROBIN" },
              { "name" => "LEAST_CONNECTIONS"}
            ]
          }

          response

        end
      end
    end
  end
end