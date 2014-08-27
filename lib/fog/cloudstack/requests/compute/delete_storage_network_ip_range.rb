module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a storage network IP Range.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteStorageNetworkIpRange.html]
        def delete_storage_network_ip_range(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteStorageNetworkIpRange') 
          else
            options.merge!('command' => 'deleteStorageNetworkIpRange', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

