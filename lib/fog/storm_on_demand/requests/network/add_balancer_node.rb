module Fog
  module Network
    class StormOnDemand
      class Real
        def add_balancer_node(options = {})
          request(
            :path     => "/Network/LoadBalancer/addNode",
            :body     => Fog::JSON.encode({:params => options})
          )
        end
      end
    end
  end
end
