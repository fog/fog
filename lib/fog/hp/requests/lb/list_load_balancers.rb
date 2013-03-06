module Fog
  module HP
    class LB
      class Real
        def list_load_balancers
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'loadbalancers'
          )
          response
        end

      end
      class Mock
        def list_load_balancers
          response = Excon::Response.new
          response.status = 200
          response.body = {
              "loadBalancers" => [
                {
                  "name"      => "lb-site1",
                  "id"        => "71",
                  "protocol"  => "HTTP",
                  "port"      => "80",
                  "algorithm" => "LEAST_CONNECTIONS",
                  "status"    => "ACTIVE",
                  "created"   => "2010-11-30T03=>23=>42Z",
                  "updated"   => "2010-11-30T03=>23=>44Z"
              },
                {
                  "name"      => "lb-site2",
                  "id"        => "166",
                  "protocol"  => "TCP",
                  "port"      => "9123",
                  "algorithm" => "ROUND_ROBIN",
                  "status"    => "ACTIVE",
                  "created"   => "2010-11-30T03:23:42Z",
                  "updated"   => "2010-11-30T03:23:44Z"
              }
            ]
          }
          response
        end
      end
    end
  end
end