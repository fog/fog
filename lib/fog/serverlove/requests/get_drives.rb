module Fog
  module Compute
    class Serverlove
      class Real

        def get_drives
          request("get", "/drives/list", [200])
        end

      end
    end
  end
end