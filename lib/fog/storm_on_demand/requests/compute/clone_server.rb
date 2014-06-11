module Fog
  module Compute
    class StormOnDemand
      class Real
        def clone_server(options = {})
          request(
            :path     => "/Storm/Server/clone",
            :body     => Fog::JSON.encode({:params => options})
          )
        end
      end
    end
  end
end
