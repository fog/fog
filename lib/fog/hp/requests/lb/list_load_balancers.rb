module Fog
  module HP
    class LB
      # List all load balancers
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
      #       * 'created'<~String> - created date time stamp
      #       * 'updated'<~String> - updated date time stamp
      #       * 'nodeCount'<~Integer> - Nodes attached to the load balancer
      class Real
        def list_load_balancers
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'loadbalancers'
          )
        end
      end
      class Mock
        def list_load_balancers
          response = Excon::Response.new
          lbs = self.data[:lbs].values
          response.status = 200
          response.body = { 'loadBalancers' => lbs }
          response
        end
      end
    end
  end
end
