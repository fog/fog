module Fog
  module Compute
    class Brightbox
      class Real

        def get_cloud_ip(identifier)
          return nil if identifier.nil? || identifier == ""
          request("get", "/1.0/cloud_ips/#{identifier}", [200])
        end

      end
    end
  end
end