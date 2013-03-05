module Fog
  module HP
    class LB
      class Real

        def list_limits
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'limits'
          )
          response
        end

      end
      class Mock
        def list_limits
          response = Excon::Response.new

          response
        end

      end
    end
  end
end