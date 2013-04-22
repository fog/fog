module Fog
  module Compute
    class Cloudstack
      class Real

        # Updates a disk offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteDiskOffering.html]
        def delete_disk_offering(options={})
          options.merge!(
            'command' => 'deleteDiskOffering'
          )
          request(options)
        end

      end # Real
    end # Cloudstack
  end # Compute
end # Fog
