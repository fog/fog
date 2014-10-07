module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a disk offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteDiskOffering.html]
        def delete_disk_offering(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteDiskOffering') 
          else
            options.merge!('command' => 'deleteDiskOffering', 
            'id' => args[0])
          end
          request(options)
        end
      end
 
      class Mock
        def delete_disk_offering(options={})
          disk_offering_id = options['id']
          data[:disk_offerings].delete(disk_offering_id) if data[:disk_offerings][disk_offering_id]

          { 'deletediskofferingresponse' => { 'success' => 'true' } }
        end
      end 
    end
  end
end

