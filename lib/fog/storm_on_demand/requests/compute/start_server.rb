module Fog
  module Compute
    class StormOnDemand
      class Real

        def start_server(options = {})
          request(
            :path     => "/storm/server/start",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end