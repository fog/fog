module Fog
  module Compute
    class Brightbox
      class Real

        def list_api_clients
          request("get", "/1.0/api_clients", [200])
        end

      end
    end
  end
end