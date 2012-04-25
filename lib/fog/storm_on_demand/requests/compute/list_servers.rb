module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_servers(options = {})
          request(
            :path     => "/storm/server/list",
            :body     => MultiJson.dump(options)
          )
        end

      end
    end
  end
end