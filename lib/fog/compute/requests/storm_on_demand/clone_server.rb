module Fog
  module Compute
    class StormOnDemand
      class Real

        def clone_server(options = {})
          request(
            :path     => "/storm/server/clone",
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end