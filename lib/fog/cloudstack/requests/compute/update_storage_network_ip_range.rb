module Fog
  module Compute
    class Cloudstack

      class Real
        # Update a Storage network IP range, only allowed when no IPs in this range have been allocated.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateStorageNetworkIpRange.html]
        def update_storage_network_ip_range(id, options={})
          options.merge!(
            'command' => 'updateStorageNetworkIpRange', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

