module Fog
  module Compute
    class StormOnDemand
      class Real

        def shutdown_server(options = {})
          request(
            :path     => "/storm/server/shutdown",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end