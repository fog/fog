module Fog
  module Compute
    class StormOnDemand
      class Real

        def create_balancer(options = {})
          request(
            :path     => "/network/loadbalancer/create",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end