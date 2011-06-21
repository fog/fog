module Fog
  module Compute
    class StormOnDemand
      class Real

        def create_server(options = {})
          request(
            :path     => "/storm/server/create",
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end