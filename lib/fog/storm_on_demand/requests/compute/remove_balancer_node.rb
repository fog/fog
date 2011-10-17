module Fog
  module Compute
    class StormOnDemand
      class Real

        def remove_balancer_node(options = {})
          request(
            :path     => "/network/loadbalancer/removenode",
            :body     => MultiJson.encode({:params => options})
          )
        end

      end
    end
  end
end