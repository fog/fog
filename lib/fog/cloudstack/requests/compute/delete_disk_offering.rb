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

      class Mock

        def delete_disk_offering(options={})
          disk_offering_id = options['id']
          data[:disk_offerings].delete(disk_offering_id) if data[:disk_offerings][disk_offering_id]

          { 'deletediskofferingresponse' => { 'success' => 'true' } }
        end

      end

    end # Cloudstack
  end # Compute
end # Fog
