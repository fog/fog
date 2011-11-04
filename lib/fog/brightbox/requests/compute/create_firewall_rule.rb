module Fog
  module Compute
    class Brightbox
      class Real

        def create_firewall_rule(options)
          request("post", "/1.0/firewall_rules", [202], options)
        end

      end
    end
  end
end