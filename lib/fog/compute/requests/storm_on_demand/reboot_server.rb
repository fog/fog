module Fog
  module Compute
    class StormOnDemand
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