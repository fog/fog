module Fog
  module Compute
    class Brightbox
      class Real
        # Update some settings of the firewall rule.
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
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
        # @see https://api.gb1.brightbox.com/1.0/#firewall_rule_update_firewall_rule
        #
        def update_firewall_rule(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          wrapped_request("put", "/1.0/firewall_rules/#{identifier}", [202], options)
        end
      end
    end
  end
end
