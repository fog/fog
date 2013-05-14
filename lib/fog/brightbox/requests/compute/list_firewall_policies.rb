module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of firewall policies
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#firewall_policy_list_firewall_policies
        #
        def list_firewall_policies
          wrapped_request("get", "/1.0/firewall_policies", [200])
        end

      end
    end
  end
end
