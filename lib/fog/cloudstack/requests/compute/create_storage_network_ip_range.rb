module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Storage network IP range.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createStorageNetworkIpRange.html]
        def create_storage_network_ip_range(options={})
          options.merge!(
            'command' => 'createStorageNetworkIpRange',
            'podid' => options['podid'], 
            'startip' => options['startip'], 
            'netmask' => options['netmask'], 
            'gateway' => options['gateway'], 
             
          )
          request(options)
        end
      end

    end
  end
end

