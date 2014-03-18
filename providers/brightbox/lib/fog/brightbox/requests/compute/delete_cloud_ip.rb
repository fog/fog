module Fog
  module Compute
    class Brightbox
      class Real
        # Release the cloud IP address from the account's ownership.
        #
        # @param [String] identifier Unique reference to identify the resource
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#cloud_ip_delete_cloud_ip
        #
        def delete_cloud_ip(identifier)
          return nil if identifier.nil? || identifier == ""
          wrapped_request("delete", "/1.0/cloud_ips/#{identifier}", [200])
        end

        # Old format of the delete request.
        #
        # @deprecated Use +#delete_cloud_ip+ instead
        #
        def destroy_cloud_ip(identifier)
          delete_cloud_ip(identifier)
        end
      end
    end
  end
end
