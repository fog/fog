module Fog
  module Compute
    class Brightbox
      class Real

        def list_cloud_ips
          request("get", "/1.0/cloud_ips", [200])
        end

      end
    end
  end
end