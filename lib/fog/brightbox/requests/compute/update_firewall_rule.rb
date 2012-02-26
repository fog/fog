module Fog
  module Compute
    class Brightbox
      class Real

        def update_firewall_rule(id, options)
          request("put", "/1.0/firewall_rules/#{id}", [202], options)
        end

      end
    end
  end
end
