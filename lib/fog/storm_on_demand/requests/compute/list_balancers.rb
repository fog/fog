module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_balancers(options = {})
          request(
            :path     => "/Network/LoadBalancer/list",
            :body     => Fog::JSON.encode(options)
          )
        end

      end
    end
  end
end