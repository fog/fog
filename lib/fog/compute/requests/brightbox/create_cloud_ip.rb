module Fog
  module Compute
    class Brightbox
      class Real

        def create_cloud_ip
          request("post", "/1.0/cloud_ips", [201])
        end

      end
    end
  end
end