module Fog
  module Joyent
    class Analytics
      class Real
        def delete_instrumentation(id)
          request(
              :path => "#{@joyent_username}/analytics/instrumentations/#{id}",
              :method => "DELETE",
              :expects => 204
          )
        end
      end

      class Mock
        def delete_instrumentation(id)
          response = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
