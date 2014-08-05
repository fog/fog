module Fog
  module Network
    class StormOnDemand
      class Real
        def create_balancer(options={})
          request(
            :path => '/Network/LoadBalancer/create',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
