module Fog
  module Network
    class StormOnDemand
      class Real
        def remove_balancer_service(options={})
          request(
            :path => '/Network/LoadBalancer/removeService',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
