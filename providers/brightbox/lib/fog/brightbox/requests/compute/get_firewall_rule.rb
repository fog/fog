module Fog
  module Compute
    class Brightbox
      class Real
        # Get full details of the firewall rule.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#firewall_rule_get_firewall_rule
        #
        def get_firewall_rule(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("get", "/1.0/firewall_rules/#{identifier}", [200])
        end

      end
    end
  end
end
