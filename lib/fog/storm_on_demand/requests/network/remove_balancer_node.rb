module Fog
  module Network
    class StormOnDemand
      class Real
        def remove_balancer_node(options = {})
          request(
            :path     => "/Network/LoadBalancer/removeNode",
            :body     => Fog::JSON.encode({:params => options})
          )
        end
      end
    end
  end
end
