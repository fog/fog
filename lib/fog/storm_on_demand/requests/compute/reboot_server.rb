module Fog
  module Compute
    class StormOnDemand
      class Real
        def reboot_server(options = {})
          request(
            :path     => "/Storm/Server/reboot",
            :body     => Fog::JSON.encode({:params => options})
          )
        end
      end
    end
  end
end
