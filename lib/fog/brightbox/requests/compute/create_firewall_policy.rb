module Fog
  module Compute
    class Brightbox
      class Real

        def create_firewall_policy(options)
          request("post", "/1.0/firewall_policies", [201], options)
        end

      end
    end
  end
end