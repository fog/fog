module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_balancers(options = {})
          request(
            :path     => "/network/loadbalancer/list",
            :body     => MultiJson.dump(options)
          )
        end

      end
    end
  end
end