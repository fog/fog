  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a disk offering.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateDiskOffering.html]
          def update_disk_offering(options={})
            options.merge!(
              'command' => 'updateDiskOffering'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
