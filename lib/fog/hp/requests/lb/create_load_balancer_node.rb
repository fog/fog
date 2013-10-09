module Fog
  module HP
    class LB

      # Create a new load balancer node
      #
      # ==== Parameters
      # * 'load_balancer_id'<~String> - UUId of load balancer to create node for
      # * 'nodes'<~ArrayOfHash> - Nodes for the load balancer
      #   * 'address'<~String> - Address for the node
      #   * 'port'<~String> - Port for the node
      # * options<~Hash>:
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'nodes'<~Array>:
      #       * 'id'<~String> - UUID of the node
      #       * 'address'<~String> - Address for the node
      #       * 'port'<~String> - Port for the node
      #       * 'condition'<~String> - Condition for the node
      #       * 'status'<~String> - Status for the node
      class Real
        def create_load_balancer_node(load_balancer_id, nodes, options={})
          data = {
            'nodes' => nodes
          }
          response = request(
            :body    => Fog::JSON.encode(data),
            :expects => 202,
            :method  => 'POST',
            :path    => "loadbalancers/#{load_balancer_id}/nodes"
          )

        end
      end
      class Mock
        def create_load_balancer_node(load_balancer_id, nodes, options={})
          ### Call: {"nodes" => [{"address" => "15.185.1.1", "port" => "80"}]}
          response = Excon::Response.new
          if get_load_balancer(load_balancer_id)
            response.status = 202

            data = {
                'id'        => Fog::HP::Mock.uuid.to_s,
                'address'   => nodes[0]['address'],
                'port'      => nodes[0]['port'],
                'condition' => 'ENABLED',
                'status'    => 'ONLINE'
            }

            self.data[:lbs][load_balancer_id]['nodes'] << data
            response.body = {'nodes' => [data]}
            response
          else
            raise Fog::HP::LB::NotFound
          end

        end
      end
    end

  end
end
