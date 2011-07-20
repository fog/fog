module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_configs(options = {})
          request(
            :path     => "/storm/config/list",
            :body     => MultiJson.encode(options)
          )
        end

      end
    end
  end
end