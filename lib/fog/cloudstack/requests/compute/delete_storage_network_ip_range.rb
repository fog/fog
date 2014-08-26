module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a storage network IP Range.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteStorageNetworkIpRange.html]
        def delete_storage_network_ip_range(id, options={})
          options.merge!(
            'command' => 'deleteStorageNetworkIpRange', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

