module Fog
  module HP
    class LB
      class Real
        def get_virtual_ips(load_balancer_id)
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => "loadbalancers/#{load_balancer_id}/virtualips"
          )
          response
        end

      end
      class Mock
        def get_virtual_ips(load_balancer_id)
          response = Excon::Response.new


          response

        end

      end
    end
  end
end