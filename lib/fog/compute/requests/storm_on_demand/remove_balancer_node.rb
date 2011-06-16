module Fog
  module Compute
    class StormOnDemand
      class Real

        def remove_balancer_node(options = {})
          request(
            :path     => "/network/loadbalancer/removenode",
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end