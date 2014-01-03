module Fog
  module Joyent
    class Analytics
      class Real
        def create_instrumentation(values = {})
          request(
              :path => "#{@joyent_username}/analytics/instrumentations",
              :method => "POST",
              :body => values,
              :expects => [200,201]
          )
        end
      end

      class Mock
        def create_instrumentation(values = {})
          response = Excon::Response.new
          response.status = 201
          response.body = self.data[:instrumentation]
          response
        end
      end
    end
  end
end
