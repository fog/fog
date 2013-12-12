module Fog
  module Joyent
    class Analytics
      class Real
        def list_instrumentations
          request(
              :path => "#{@joyent_username}/analytics/instrumentations",
              :method => "GET",
              :expects => 200
          )
        end
      end
    end
  end
end
