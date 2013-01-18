module Fog
  module Compute
    class StormOnDemand
      class Real

        def clone_server(options = {})
          request(
            :path     => "/storm/server/clone",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end