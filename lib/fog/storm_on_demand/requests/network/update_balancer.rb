module Fog
  module Network
    class StormOnDemand
      class Real
        def update_balancer(options={})
          request(
            :path => '/Network/LoadBalancer/update',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
