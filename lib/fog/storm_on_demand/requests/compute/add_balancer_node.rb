module Fog
  module Compute
    class StormOnDemand
      class Real

        def add_balancer_node(options = {})
          request(
            :path     => "/network/loadbalancer/addnode",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end