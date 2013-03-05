module Fog
  module HP
    class LB
      class Real
        def list_load_balancers
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'loadbalancers'
          )
          response
        end

      end
      class Mock
        def list_load_balancers
          response = Excon::Response.new


          response
        end
      end
    end
  end
end