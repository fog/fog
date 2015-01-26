module Fog
  module HP
    class LB
      # List all load balancer nodes
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'nodes'<~Array>: Nodes for the load balancer
      #       * 'id'<~String> - UUId for the node
      #       * 'address'<~String> - Address for the node
      #       * 'port'<~String> - Port for the node
      #       * 'condition'<~String> - Condition for the node e.g. 'ENABLED'
      #       * 'status'<~String> - Status for the node e.g. 'ONLINE'
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
          if lb = get_load_balancer(load_balancer_id).body
            response.status = 200
            response.body   = {'nodes' => lb['nodes']}
            response
          else
            raise Fog::HP::LB::NotFound
          end
        end
      end
    end
  end
end
