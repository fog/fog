module Fog
  module Compute
    class Brightbox
      class Real

        def unmap_cloud_ip(identifier)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/cloud_ips/#{identifier}/unmap", [202])
        end

      end
    end
  end
end