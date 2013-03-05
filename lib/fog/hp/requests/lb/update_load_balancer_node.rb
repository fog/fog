module Fog
  module HP
    class LB
      class Real
        def update_load_balancer_node(load_balancer_id, node_id, condition)
          data = {
            #ENABLED | DISABLED
            "condition" => condition
          }
          request(
            :body    => Fog::JSON.encode(data),
            :expects => 202,
            :method  => 'PUT',
            :path    => "loadbalancers/#{load_balancer_id}/nodes/#{node_id}"
          )

        end
      end
      class Mock
        def update_load_balancer_node(load_balancer_id, node_id, condition)
          response = Excon::Response.new


          response
        end
      end
    end
  end
end