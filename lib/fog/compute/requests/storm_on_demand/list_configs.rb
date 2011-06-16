module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_configs(options = {})
          request(
            :path     => "/storm/config/list",
            :body     => options.to_json
          )
        end

      end
    end
  end
end