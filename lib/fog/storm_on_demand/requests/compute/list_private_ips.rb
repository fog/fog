module Fog
  module Compute
    class StormOnDemand
      class Real

        def list_private_ips(options = {})
          request(
            :path     => "/network/private/get",
            :body     => MultiJson.encode(options)
          )
        end

      end
    end
  end
end