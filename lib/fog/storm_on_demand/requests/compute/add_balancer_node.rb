module Fog
  module Compute
    class StormOnDemand
      class Real

        def add_balancer_node(options = {})
          request(
            :path     => "/network/loadbalancer/addnode",
            :body     => MultiJson.dump({:params => options})
          )
        end

      end
    end
  end
end