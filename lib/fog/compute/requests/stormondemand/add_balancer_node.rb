module Fog
  module StormOnDemand
    class Compute
      class Real

        def add_balancer_node(options = {})
          request(
            :path     => "/network/loadbalancer/addnode",
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end