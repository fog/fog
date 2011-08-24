module Fog
  module Compute
    class Brightbox
      class Real

        def list_server_groups
          request("get", "/1.0/server_groups", [200])
        end

      end
    end
  end
end