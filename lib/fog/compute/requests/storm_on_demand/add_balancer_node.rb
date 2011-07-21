module Fog
  module Compute
    class StormOnDemand
      class Real

        def add_balancer_node(options = {})
          request(
            :path     => "/network/loadbalancer/addnode",
            :body     => MultiJson.encode({:params => options})
          )
        end

      end
    end
  end
end