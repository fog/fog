module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_balancers(options = {})
          request(
            :path     => "/network/loadbalancer/list",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end