module Fog
  module Compute
    class Brightbox
      class Real
        # Create a new firewall rule for a firewall policy.
        #
        # @param [Hash] options
        # @option options [String] :firewall_policy
        # @option options [String] :protocol
        # @option options [String] :source Required unless destination is set.
        # @option options [String] :source_port
        # @option options [String] :destination Required unless source is set
        # @option options [String] :destination_port
        # @option options [String] :icmp_type_name
        # @option options [String] :description
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#firewall_rule_create_firewall_rule
        #
        def create_firewall_rule(options)
          wrapped_request("post", "/1.0/firewall_rules", [202], options)
        end

      end
    end
  end
end
