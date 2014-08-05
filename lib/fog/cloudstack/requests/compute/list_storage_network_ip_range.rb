module Fog
  module Compute
    class Cloudstack

      class Real
        # List a storage network IP range.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listStorageNetworkIpRange.html]
        def list_storage_network_ip_range(options={})
          options.merge!(
            'command' => 'listStorageNetworkIpRange'  
          )
          request(options)
        end
      end

    end
  end
end

