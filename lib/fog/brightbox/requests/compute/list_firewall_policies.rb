module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of firewall policies
        #
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#firewall_policy_list_firewall_policies
        #
        def list_firewall_policies
          request("get", "/1.0/firewall_policies", [200])
        end

      end
    end
  end
end
