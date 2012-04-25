module Fog
  module Compute
    class StormOnDemand
      class Real

        def resize_server(options = {})
          request(
            :path     => "/storm/server/resize",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end