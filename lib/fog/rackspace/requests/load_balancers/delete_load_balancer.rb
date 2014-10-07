module Fog
  module Rackspace
    class LoadBalancers
      class Real
        def delete_load_balancer(load_balancer_id)
          request(
            :expects => 202,
            :path => "loadbalancers/#{load_balancer_id}.json",
            :method => 'DELETE'
          )
        end
      end

      class Mock
        def delete_load_balancer(load_balancer_id)
          response = Excon::Response.new
          response.status = 202
          response.body = ""
        end
      end
    end
  end
end
