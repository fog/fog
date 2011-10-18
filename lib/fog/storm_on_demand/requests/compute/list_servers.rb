module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_servers(options = {})
          request(
            :path     => "/storm/server/list",
            :body     => MultiJson.encode(options)
          )
        end

      end
    end
  end
end