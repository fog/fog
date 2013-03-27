module Fog
  module Compute
    class StormOnDemand
      class Real

        def delete_balancer(options = {})
          request(
            :path     => "/network/loadbalancer/delete",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end