module Fog
  module HP
    class LB
      # Update an existing load balancer node
      #
      # ==== Parameters
      # * 'load_balancer_id'<~String> - UUId of the load balancer to update
      # * 'node_id'<~String> - UUId of node to update
      # * options<~Hash>:
      #   * 'condition'<~String> - Condition for the node. Valid values are []'ENABLED', 'DISABLED']
      class Real
        def update_load_balancer_node(load_balancer_id, node_id, condition)
          data = {
            'condition' => condition
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
          if lb_data = get_load_balancer(load_balancer_id)
            if get_load_balancer_node(load_balancer_id, node_id)
              nodes = update_node(lb_data, node_id, condition)
              self.data[:lbs][load_balancer_id]['nodes'] = nodes
              response.status = 202
              response
            else
              raise Fog::HP::LB::NotFound
            end
          else
            raise Fog::HP::LB::NotFound
          end
        end

        def update_node(lb_data, node_id, condition)
          nodes = lb_data.body['nodes']
          node = nodes.select {|n| n['id'] == node_id}.first
          # update the node attributes
          if node
            node['condition'] = condition
            node['status'] = condition == 'ENABLED' ? 'ONLINE' : 'OFFLINE'
          end
          new_nodes = nodes.reject {|n| n['id'] == node_id}
          new_nodes << node
        end
      end
    end
  end
end
