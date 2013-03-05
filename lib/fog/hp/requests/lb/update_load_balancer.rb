module Fog
  module HP
    class LB
      class Real
        def update_load_balancer(load_balancer_id, options=())
          request(
            :body    => Fog::JSON.encode(options),
            :expects => 202,
            :method  => 'PUT',
            :path    => "loadbalancers/#{load_balancer_id}"
          )
        end

      end
      class Mock
        def update_load_balancer(load_balancer_id, options={})
          response = Excon::Response.new


          response
        end
      end
    end
  end
end