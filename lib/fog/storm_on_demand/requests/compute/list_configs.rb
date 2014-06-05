module Fog
  module Compute
    class StormOnDemand
      class Real
        def list_configs(options = {})
          request(
            :path     => "/storm/config/list",
            :body     => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
