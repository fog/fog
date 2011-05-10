module Fog
  module StormOnDemand
    class Compute
      class Real

        def reboot_server(options = {})
          request(
            :path     => "/storm/server/reboot",
            :body     => {:params => options}.to_json
          )
        end

      end
    end
  end
end