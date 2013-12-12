module Fog
  module Joyent
    class Analytics
      class Real
        def create_instrumentation(values = {})
          request(
              :path => "#{@joyent_username}/analytics/instrumentations",
              :method => "POST",
              :body => values,
              :expects => 200
          )
        end
      end
    end
  end
end
