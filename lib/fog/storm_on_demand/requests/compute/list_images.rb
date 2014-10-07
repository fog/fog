module Fog
  module Compute
    class StormOnDemand
      class Real
        def list_images(options = {})
          request(
            :path     => "/Storm/Image/list",
            :body     => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
