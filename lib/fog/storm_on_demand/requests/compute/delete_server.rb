module Fog
  module Compute
    class StormOnDemand
      class Real
        def delete_server(options = {})
          request(
            :path     => "/Storm/Server/destroy",
            :body     => Fog::JSON.encode({:params => options})
          )
        end
      end
    end
  end
end
