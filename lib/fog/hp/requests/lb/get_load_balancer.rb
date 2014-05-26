module Fog
  module HP
    class LB
      # Get details for an existing load balancer
      #
      # ==== Parameters
      # * 'load_balancer_id'<~String> - UUId of the load balancer to get
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'loadBalancers'<~Array>:
      #       * 'id'<~String> - UUID of the load balancer
      #       * 'name'<~String> - Name of the load balancer
      #       * 'protocol'<~String> - Protocol for the load balancer
      #       * 'port'<~String> - Port for the load balancer
      #       * 'algorithm'<~String> - Algorithm for the load balancer
      #       * 'status'<~String> - Status for the load balancer
      #       * 'statusDescription'<~String> - Desc. of Status for the load balancer
      #       * 'created'<~String> - created date time stamp
      #       * 'updated'<~String> - updated date time stamp
      #       * 'nodeCount'<~Integer> - Nodes attached to the load balancer
      #       * 'nodes'<~ArrayOfHash> - Nodes for the load balancer
      #         * 'id'<~String> - UUId for the node
      #         * 'address'<~String> - Address for the node
      #         * 'port'<~String> - Port for the node
      #         * 'condition'<~String> - Condition for the node e.g. 'ENABLED'
      #         * 'status'<~String> - Status for the node e.g. 'ONLINE'
      #       * 'virtualIps'<~ArrayOfHash> - Virtual IPs for the load balancer
      #         * 'id'<~String> - UUId for the virtual IP
      #         * 'address'<~String> - Address for the virtual IP
      #         * 'type'<~String> - Type for the virtual IP
      #         * 'ipVersion'<~String> - IP Version for the virtual IP
      class Real
        def get_load_balancer(load_balancer_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => "loadbalancers/#{load_balancer_id}"
          )
        end
      end
      class Mock
        def get_load_balancer(load_balancer_id)
          response = Excon::Response.new
          if lb = list_load_balancers.body['loadBalancers'].find { |_| _['id'] == load_balancer_id }
            response.status = 200
            response.body = lb
            response
          else
            raise Fog::HP::LB::NotFound
          end
        end
      end
    end
  end
end
