module Fog
  module Compute
    class Brightbox
      class Real

        def list_server_types
          request("get", "/1.0/server_types", [200])
        end

      end
    end
  end
end