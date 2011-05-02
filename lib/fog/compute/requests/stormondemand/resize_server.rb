module Fog
  module StormOnDemand
    class Compute
      class Real

        def resize_server(options = {})
          request(
            :path     => "/storm/server/resize",
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end