module Fog
  module Compute
    class Brightbox
      class Real

        def map_cloud_ip(identifier, options)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/cloud_ips/#{identifier}/map", [202], options)
        end

      end
    end
  end
end