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
          if load_b = get_load_balancer(load_balancer_id).body
           if node = find_node(load_b,node_id)
             response.status = 200
             response.body = node
           else
             raise Fog::HP::LB::NotFound
           end
          else
            raise Fog::HP::LB::NotFound
          end

          response
        end

        def find_node(lb,node_id)
          lb['nodes'].detect { |_| _['id'] == node_id }
        end

      end
    end
  end
end