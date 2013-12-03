module Fog
  module Compute
    class Brightbox
      class Real
        # Applies firewall policy to given server group
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :server_group Server Group to apply to
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#firewall_policy_apply_to_firewall_policy
        #
        def apply_to_firewall_policy(identifier, options)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/firewall_policies/#{identifier}/apply_to", [202], options)
        end

      end
    end
  end
end
