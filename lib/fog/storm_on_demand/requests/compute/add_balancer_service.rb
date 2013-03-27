module Fog
  module Compute
    class StormOnDemand
      class Real

        def add_balancer_service(options = {})
          request(
            :path     => "/network/loadbalancer/addservice",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end