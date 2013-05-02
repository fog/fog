  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a Storage network IP range.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createStorageNetworkIpRange.html]
          def create_storage_network_ip_range(options={})
            options.merge!(
              'command' => 'createStorageNetworkIpRange'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
