module Fog
  module Joyent
    class Analytics
      class Real
        def get_instrumentation(id)
          request(
              :path => "#{@joyent_username}/analytics/instrumentations/#{id}",
              :method => "GET",
              :expects => 200,
              :idempotent => true
          )
        end
      end

      class Mock
        def get_instrumentation(id)
          raise Fog::Compute::Joyent::Errors::NotFound.new('not found') unless id == self.data[:instrumentation]['id']
          response = Excon::Response.new
          response.status = 200
          response.body = self.data[:instrumentation]
          response
        end
      end
    end
  end
end
