module Fog
  module Compute
    class StormOnDemand
      class Real

        def delete_server(options = {})
          request(
            :path     => "/storm/server/destroy",
            :body     => Fog::JSON.encode({:params => options})
          )
        end

      end
    end
  end
end