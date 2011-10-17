module Fog
  module Compute
    class Brightbox
      class Real

        def list_firewall_policies
          request("get", "/1.0/firewall_policies", [200])
        end

      end
    end
  end
end