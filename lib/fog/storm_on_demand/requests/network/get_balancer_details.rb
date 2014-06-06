module Fog
  module Network
    class StormOnDemand
      class Real
        def get_balancer_details(options={})
          request(
            :path => '/Network/LoadBalancer/details',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
