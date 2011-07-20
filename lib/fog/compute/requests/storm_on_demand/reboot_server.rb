module Fog
  module Compute
    class StormOnDemand
      class Real

        def reboot_server(options = {})
          request(
            :path     => "/storm/server/reboot",
            :body     => MultiJson.encode({:params => options})
          )
        end

      end
    end
  end
end