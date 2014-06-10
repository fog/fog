module Fog
  module Network
    class StormOnDemand
      class Real
        def list_balancers(options = {})
          request(
            :path     => "/Network/LoadBalancer/list",
            :body     => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
