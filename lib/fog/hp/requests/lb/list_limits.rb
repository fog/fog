module Fog
  module HP
    class LB
      # List limits
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      #     * 'limits'<~Hash>:
      #       * 'absolute'<~Hash>:
      #         * 'values'<~Hash>:
      #           * 'maxLoadBalancerNameLength'<~Integer> - Limit of the name of the load balancer
      #           * 'maxLoadBalancers'<~Integer> - Limit of the number of the load balancer
      #           * 'maxVIPsPerLoadBalancer'<~Integer> - Limit of the virtual IPs per load balancer
      #           * 'maxNodesPerLoadBalancer'<~Integer> - Limit of the nodes per load balancer
      class Real
        def list_limits
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'limits'
          )
        end
      end
      class Mock
        def list_limits
          response        = Excon::Response.new
          limits          = self.data[:limits].values
          response.status = 200
          response.body   = { 'limits' => limits }
          response
        end
      end
    end
  end
end
