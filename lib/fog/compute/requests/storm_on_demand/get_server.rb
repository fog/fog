module Fog
  module Compute
    class StormOnDemand
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