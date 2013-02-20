module Fog
  module Compute
    class StormOnDemand
      class Real

        def get_balancer(options = {})
          request(
            :path     => "/network/loadbalancer/details",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end