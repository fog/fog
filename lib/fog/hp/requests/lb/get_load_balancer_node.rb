module Fog
  module HP
    class LB
      class Real
      # Get details for an existing load balancer node
      #
      # ==== Parameters
      # * 'load_balancer_id'<~String> - UUId of the load balancer to get
      # * 'node_id'<~String> - UUId of node to get
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'id'<~String> - UUId for the node
      #     * 'address'<~String> - Address for the node
      #     * 'port'<~String> - Port for the node
      #     * 'condition'<~String> - Condition for the node e.g. 'ENABLED'
      #     * 'status'<~String> - Status for the node e.g. 'ONLINE'
        def get_load_balancer_node(load_balancer_id, node_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "loadbalancers/#{load_balancer_id}/nodes/#{node_id}"
          )
        end
      end

      class Mock
        def get_load_balancer_node(load_balancer_id, node_id)
          response = Excon::Response.new
          if get_load_balancer(load_balancer_id)
           if node = find_node(load_balancer_id, node_id)
             response.status = 200
             response.body = node
             response
           else
             raise Fog::HP::LB::NotFound
           end
          else
            raise Fog::HP::LB::NotFound
          end
        end

        def find_node(load_balancer_id, node_id)
          nodes = list_load_balancer_nodes(load_balancer_id).body['nodes']
          nodes.find {|n| n['id'] == node_id}
        end
      end
    end
  end
end
