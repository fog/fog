module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a disk offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateDiskOffering.html]
        def update_disk_offering(id, options={})
          options.merge!(
            'command' => 'updateDiskOffering', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

