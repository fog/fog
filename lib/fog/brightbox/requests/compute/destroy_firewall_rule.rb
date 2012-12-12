module Fog
  module Compute
    class Brightbox
      class Real
        # Destroy the firewall rule.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#firewall_rule_destroy_firewall_rule
        #
        def destroy_firewall_rule(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/firewall_rules/#{identifier}", [202])
        end

      end
    end
  end
end
