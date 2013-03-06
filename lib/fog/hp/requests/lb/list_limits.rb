module Fog
  module HP
    class LB
      class Real

        def list_limits
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'limits'
          )
          response
        end

      end
      class Mock
        def list_limits
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "limits" => {
              "absolute" => {
                "values" => {
                  "maxLoadBalancerNameLength" => 128,
                  "maxLoadBalancers"          => 20,
                  "maxNodesPerLoadBalancer"   => 5,
                  "maxVIPsPerLoadBalancer"    => 1
                }
              }
            }
          }

          response
        end

      end
    end
  end
end