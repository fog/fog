module Fog
  module Compute
    class Brightbox
      class Real
        # Lists summary details of cloud IP addresses owned by the account.
        #
        #
        # @return [Hash] if successful Hash version of JSON object
        #
        # @see https://api.gb1.brightbox.com/1.0/#cloud_ip_list_cloud_ips
        #
        def list_cloud_ips
          wrapped_request("get", "/1.0/cloud_ips", [200])
        end
      end
    end
  end
end
