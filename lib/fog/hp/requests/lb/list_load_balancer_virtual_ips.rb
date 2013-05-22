module Fog
  module HP
    class LB
      class Real
        def list_load_balancer_virtual_ips(load_balancer_id)
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => "loadbalancers/#{load_balancer_id}/virtualips"
          )
          response
        end
      end
      class Mock
        def list_load_balancer_virtual_ips(load_balancer_id)
          response = Excon::Response.new
          if lb = find_load_balancer(load_balancer_id)
            response.status = 200
            response.body   = {
              "virtualIps" => [
                {
                  "id"        => "1410",
                  "address"   => "101.1.1.1",
                  "type"      => "PUBLIC",
                  "ipVersion" => "IPV4"
                },
                {
                  "id"        => "1236",
                  "address"   => "101.1.1.2",
                  "type"      => "PUBLIC",
                  "ipVersion" => "IPV4"
                },
                {
                  "id"        => "2815",
                  "address"   => "101.1.1.3",
                  "type"      => "PUBLIC",
                  "ipVersion" => "IPV4"
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
