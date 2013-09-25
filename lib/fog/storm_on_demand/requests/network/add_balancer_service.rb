module Fog
  module Network
    class StormOnDemand
      class Real

        def add_balancer_service(options={})
          request(
            :path => '/Network/LoadBalancer/addService',
            :body => Fog::JSON.encode(:params => options)
          )
        end

      end
    end
  end
end
