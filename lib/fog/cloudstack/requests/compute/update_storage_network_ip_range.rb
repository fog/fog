  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Update a Storage network IP range, only allowed when no IPs in this range have been allocated.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateStorageNetworkIpRange.html]
          def update_storage_network_ip_range(options={})
            options.merge!(
              'command' => 'updateStorageNetworkIpRange'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
