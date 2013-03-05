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


          response
        end
      end
    end
  end
end