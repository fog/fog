module Fog
  module Compute
    class Cloudstack

      class Real
        # Update a Storage network IP range, only allowed when no IPs in this range have been allocated.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateStorageNetworkIpRange.html]
        def update_storage_network_ip_range(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateStorageNetworkIpRange') 
          else
            options.merge!('command' => 'updateStorageNetworkIpRange', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

