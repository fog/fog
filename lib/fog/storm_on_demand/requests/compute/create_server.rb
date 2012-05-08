module Fog
  module Compute
    class StormOnDemand
      class Real

        def create_server(options = {})
          request(
            :path     => "/storm/server/create",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end