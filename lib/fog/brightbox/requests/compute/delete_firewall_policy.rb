module Fog
  module Compute
    class Brightbox
      class Real
        # Destroy the firewall policy if not in use.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#firewall_policy_delete_firewall_policy
        #
        def delete_firewall_policy(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("delete", "/1.0/firewall_policies/#{identifier}", [202])
        end

        # Old format of the delete request.
        #
        # @deprecated Use +#delete_firewall_policy+ instead
        #
        def destroy_firewall_policy(identifier)
          delete_firewall_policy(identifier)
        end
      end
    end
  end
end
