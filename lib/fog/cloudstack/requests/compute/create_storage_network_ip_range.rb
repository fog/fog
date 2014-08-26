module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Storage network IP range.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createStorageNetworkIpRange.html]
        def create_storage_network_ip_range(options={})
          request(options)
        end


        def create_storage_network_ip_range(podid, netmask, gateway, startip, options={})
          options.merge!(
            'command' => 'createStorageNetworkIpRange', 
            'podid' => podid, 
            'netmask' => netmask, 
            'gateway' => gateway, 
            'startip' => startip  
          )
          request(options)
        end
      end

    end
  end
end

