module Fog
  module Compute
    class Brightbox
      class Real
        # Removes firewall policy from given server group
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :server_group Server Group to remove
        #
        # @return [Hash, nil] The JSON response parsed to a Hash or nil if no options passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#firewall_policy_remove_firewall_policy
        #
        def remove_firewall_policy(identifier, options)
          return nil if identifier.nil? || identifier == ""
          request("post", "/1.0/firewall_policies/#{identifier}/remove", [202], options)
        end

      end
    end
  end
end
