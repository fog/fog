module Fog
  module HP
    class LB
      class Real

        def delete_load_balancer_node(instance_id, node_id)
          response = request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "loadbalancers/#{instance_id}/nodes/#{node_id}"
          )
          response
        end

      end
      class Mock

        def delete_load_balancer_node(instance_id, node_id)
          response = Excon::Response.new
          response = Excon::Response.new
          if load_b = get_load_balancer(instance_id).body
            if node = find_node(load_b, node_id)
              response.status = 202
            else
              raise Fog::HP::LB::NotFound
            end
          else
            raise Fog::HP::LB::NotFound
          end
          response
        end

        def find_node(lb, node_id)
          lb['nodes'].detect { |_| _['id'] == node_id }
        end
      end
    end
  end
end