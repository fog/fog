module Fog
  module Compute
    class Brightbox
      class Real

        def list_zones
          request("get", "/1.0/zones", [200])
        end

      end
    end
  end
end