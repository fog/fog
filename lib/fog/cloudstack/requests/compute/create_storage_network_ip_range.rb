module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Storage network IP range.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createStorageNetworkIpRange.html]
        def create_storage_network_ip_range(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createStorageNetworkIpRange') 
          else
            options.merge!('command' => 'createStorageNetworkIpRange', 
            'podid' => args[0], 
            'netmask' => args[1], 
            'gateway' => args[2], 
            'startip' => args[3])
          end
          request(options)
        end
      end

    end
  end
end

