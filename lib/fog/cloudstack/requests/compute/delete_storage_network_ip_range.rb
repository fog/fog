  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a storage network IP Range.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteStorageNetworkIpRange.html]
          def delete_storage_network_ip_range(options={})
            options.merge!(
              'command' => 'deleteStorageNetworkIpRange'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
