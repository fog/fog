module Fog
  module Compute
    class Brightbox
      class Real
        # Release the cloud IP address from the account's ownership.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] The JSON response parsed to a Hash
        #
        # @see https://api.gb1.brightbox.com/1.0/#cloud_ip_destroy_cloud_ip
        #
        def destroy_cloud_ip(identifier)
          return nil if identifier.nil? || identifier == ""
          request("delete", "/1.0/cloud_ips/#{identifier}", [200])
        end

      end
    end
  end
end
