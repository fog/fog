module Fog
  module Network
    class StormOnDemand
      class Real
        def get_balancer_possible_nodes(options={})
          request(
            :path => '/Network/LoadBalancer/possibleNodes',
            :body => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
