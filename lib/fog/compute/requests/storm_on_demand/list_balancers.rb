module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_balancers(options = {})
          request(
            :path     => "/network/loadbalancer/list",
            :body     => options.to_json
          )
        end

      end
    end
  end
end