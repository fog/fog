module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_servers(options = {})
          request(
            :path     => "/storm/server/list",
            :body     => options.to_json
          )
        end

      end
    end
  end
end