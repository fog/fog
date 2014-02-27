module Fog
  module Compute
    class Brightbox
      class Real
        # Get full details of the cloud IP address.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#cloud_ip_get_cloud_ip
        #
        def get_cloud_ip(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("get", "/1.0/cloud_ips/#{identifier}", [200])
        end

      end
    end
  end
end
