module Fog
  module Joyent
    class Analytics
      class Real
        def list_instrumentations
          request(
              :path => "#{@joyent_username}/analytics/instrumentations",
              :method => "GET",
              :expects => 200,
              :idempotent => true
          )
        end
      end

      class Mock
        def list_instrumentations
          response = Excon::Response.new
          response.status = 200
          response.body = [self.data[:instrumentation]]
          response
        end
      end
    end
  end
end
