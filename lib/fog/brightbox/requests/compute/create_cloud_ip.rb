module Fog
  module Compute
    class Brightbox
      class Real

        def create_cloud_ip(options = nil)
          request("post", "/1.0/cloud_ips", [201],options)
        end

      end
    end
  end
end
