module Fog
  module StormOnDemand
    class Compute
      class Real

        def list_private_ips(options = {})
          request(
            :path     => "/network/private/get",
            :body     => options.to_json
          )
        end

      end
    end
  end
end