module Fog
  module Compute
    class Brightbox
      class Real
        # Unmaps a cloud IP address from its current destination making it available to remap. This remains in the account's pool of addresses.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#cloud_ip_unmap_cloud_ip
        #
        def unmap_cloud_ip(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("post", "/1.0/cloud_ips/#{identifier}/unmap", [202])
        end

      end
    end
  end
end
