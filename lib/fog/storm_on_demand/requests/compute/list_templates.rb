module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_templates(options = {})
          request(
            :path     => "/server/template/list",
            :body     => MultiJson.encode(options)
          )
        end

      end
    end
  end
end