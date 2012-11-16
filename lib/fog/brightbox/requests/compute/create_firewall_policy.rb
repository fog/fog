module Fog
  module Compute
    class Brightbox
      class Real
        # Create a new firewall policy for the account.
        #
        # Optionally applying to a server group at creation time.
        #
        # @param [Hash] options
        # @option options [String] :server_group
        # @option options [String] :name Editable label
        #
        # @return [Hash, nil] The JSON response parsed to a Hash or nil if no options passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#firewall_policy_create_firewall_policy
        #
        def create_firewall_policy(options)
          request("post", "/1.0/firewall_policies", [201], options)
        end

      end
    end
  end
end
