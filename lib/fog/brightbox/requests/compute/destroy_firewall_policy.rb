module Fog
  module Compute
    class Brightbox
      class Real

        def destroy_firewall_policy(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/firewall_policies/#{identifier}", [202])
        end

      end
    end
  end
end