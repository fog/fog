module Fog
  module HP
    class LB
      class Real
        def list_load_balancer_nodes(load_balancer_id)
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => "loadbalancers/#{load_balancer_id}/nodes"
          )
          response
        end
      end
      class Mock
        def list_load_balancer_nodes(load_balancer_id)
          response = Excon::Response.new
          if lb = find_load_balancer(load_balancer_id)
            response.status = 200
            response.body   = {
              "nodes" => [
                {
                  "id"        => "410",
                  "address"   => "10.1.1.1",
                  "port"      => "80",
                  "condition" => "ENABLED",
                  "status"    => "ONLINE"
                },
                {
                  "id"        => "236",
                  "address"   => "10.1.1.2",
                  "port"      => "80",
                  "condition" => "ENABLED",
                  "status"    => "ONLINE"
                },
                {
                  "id"        => "2815",
                  "address"   => "10.1.1.3",
                  "port"      => "83",
                  "condition" => "DISABLED",
                  "status"    => "OFFLINE"
                },
              ]
            }
          else
            raise Fog::HP::LB::NotFound
          end

          response

        end

        def find_load_balancer(record_id)
          list_load_balancers.body['loadBalancers'].detect { |_| _['id'] == record_id }
        end
      end
    end
  end
end
