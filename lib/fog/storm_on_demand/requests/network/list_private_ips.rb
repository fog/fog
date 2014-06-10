module Fog
  module Network
    class StormOnDemand
      class Real
        def list_private_ips(options = {})
          request(
            :path     => "/Network/Private/get",
            :body     => Fog::JSON.encode(:params => options)
          )
        end
      end
    end
  end
end
