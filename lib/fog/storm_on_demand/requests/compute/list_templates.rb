module Fog
  module Compute
    class StormOnDemand
      class Real
        def list_templates(options = {})
          request(
            :path     => "/Storm/Template/list",
            :body     => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
