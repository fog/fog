module Fog
  module HP
    class LB
      class Real
        def get_load_balancer_node(load_balancer_id, node_id)
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => "loadbalancers/#{load_balancer_id}/nodes/#{node_id}"
          )
          response

        end
      end
      class Mock
        def get_load_balancer_node(load_balancer_id, node_id)
          response = Excon::Response.new


          response
        end
      end
    end
  end
end