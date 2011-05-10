module Fog
  module StormOnDemand
    class Compute
      class Real

        def get_server(options = {})
          request(
            :path     => "/storm/server/details",
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end