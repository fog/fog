module Fog
  module Compute
    class Brightbox
      class Real

        def apply_to_firewall_policy(identifier, options)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/firewall_policies/#{identifier}/apply_to", [202], options)
        end

      end
    end
  end
end