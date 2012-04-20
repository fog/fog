module Fog
  module Compute
    class StormOnDemand
      class Real

        def remove_balancer_node(options = {})
          request(
            :path     => "/network/loadbalancer/removenode",
            :body     => MultiJson.dump({:params => options})
          )
        end

      end
    end
  end
end