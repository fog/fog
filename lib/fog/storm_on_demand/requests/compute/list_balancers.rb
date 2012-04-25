module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_balancers(options = {})
          request(
            :path     => "/network/loadbalancer/list",
            :body     => Fog::JSON.encode(options)
          )
        end

      end
    end
  end
end