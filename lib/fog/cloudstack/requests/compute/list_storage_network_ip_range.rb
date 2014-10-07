module Fog
  module Compute
    class Cloudstack

      class Real
        # List a storage network IP range.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listStorageNetworkIpRange.html]
        def list_storage_network_ip_range(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listStorageNetworkIpRange') 
          else
            options.merge!('command' => 'listStorageNetworkIpRange')
          end
          request(options)
        end
      end

    end
  end
end

