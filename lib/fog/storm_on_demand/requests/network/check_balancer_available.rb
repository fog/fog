module Fog
  module Network
    class StormOnDemand
      class Real
        def check_balancer_available(options={})
          request(
            :path => '/Network/LoadBalancer/available',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
