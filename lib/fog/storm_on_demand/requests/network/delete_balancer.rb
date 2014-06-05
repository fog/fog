module Fog
  module Network
    class StormOnDemand
      class Real
        def delete_balancer(options={})
          request(
            :path => '/Network/LoadBalancer/delete',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
