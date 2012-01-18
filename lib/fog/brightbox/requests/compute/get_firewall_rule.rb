module Fog
  module Compute
    class Brightbox
      class Real

        def get_firewall_rule(identifier)
          return nil if identifier.nil? || identifier == ""
          request("get", "/1.0/firewall_rules/#{identifier}", [200])
        end

      end
    end
  end
end