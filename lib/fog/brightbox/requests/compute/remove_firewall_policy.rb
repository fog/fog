module Fog
  module Compute
    class Brightbox
      class Real

        def remove_firewall_policy(identifier, options)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/firewall_policies/#{identifier}/remove", [202], options)
        end

      end
    end
  end
end