module Fog
  module HP
    class LB
      # Delete an existing load balancer node
      #
      # ==== Parameters
      # * 'load_balancer_id'<~String> - UUId of load balancer for the node
      # * 'node_id'<~String> - UUId of node to delete
      #
      class Real
        def delete_load_balancer_node(load_balancer_id, node_id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :path    => "loadbalancers/#{load_balancer_id}/nodes/#{node_id}"
          )
        end
      end
      class Mock
        def delete_load_balancer_node(load_balancer_id, node_id)
          response = Excon::Response.new
          if get_load_balancer(load_balancer_id)
            if get_load_balancer_node(load_balancer_id, node_id)
              response.status = 202
              nodes = delete_node(load_balancer_id, node_id)
              self.data[:lbs][load_balancer_id]['nodes'] = nodes
              response
            else
              raise Fog::HP::LB::NotFound
            end
          else
            raise Fog::HP::LB::NotFound
          end
        end

        def delete_node(load_balancer_id, node_id)
          nodes = list_load_balancer_nodes(load_balancer_id).body['nodes']
          nodes.reject {|n| n['id'] == node_id}
        end
      end
    end
  end
end
