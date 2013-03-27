module Fog
  module Compute
    class StormOnDemand
      class Real

        def remove_balancer_service(options = {})
          request(
            :path     => "/network/loadbalancer/removeservice",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end