module Fog
  module Compute
    class Brightbox
      class Real
        # Updates details of the firewall policy
        #
        # @param [String] identifier Unique reference to identify the resource
        # @param [Hash] options
        # @option options [String] :name Editable label
        # @option options [String] :description Longer editable description
        #
        # @return [Hash] if successful Hash version of JSON object
        # @return [NilClass] if no options were passed
        #
        # @see https://api.gb1.brightbox.com/1.0/#firewall_policy_update_firewall_policy
        #
        def update_firewall_policy(identifier, options)
          return nil if identifier.nil? || identifier == ""
          return nil if options.empty? || options.nil?
          wrapped_request("put", "/1.0/firewall_policies/#{identifier}", [200], options)
        end

      end
    end
  end
end
