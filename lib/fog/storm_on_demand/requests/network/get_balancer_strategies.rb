module Fog
  module Network
    class StormOnDemand
      class Real

        def get_balancer_strategies(options={})
          request(
            :path => '/Network/LoadBalancer/strategies',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
