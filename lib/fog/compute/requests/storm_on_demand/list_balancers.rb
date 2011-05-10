module Fog
  module StormOnDemand
    class Compute
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