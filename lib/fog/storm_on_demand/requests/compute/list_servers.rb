module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_servers(options = {})
          request(
            :path     => "/storm/server/list",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end