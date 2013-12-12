module Fog
  module Joyent
    class Analytics
      class Real
        def get_instrumentation(id)
          request(
              :path => "#{@joyent_username}/analytics/instrumentations/#{id}",
              :method => "GET",
              :expects => 200
          )
        end
      end
    end
  end
end
