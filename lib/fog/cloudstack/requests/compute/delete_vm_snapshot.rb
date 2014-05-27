module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a vmsnapshot.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteVMSnapshot.html]
        def delete_vm_snapshot(options={})
          options.merge!(
            'command' => 'deleteVMSnapshot', 
            'vmsnapshotid' => options['vmsnapshotid']  
          )
          request(options)
        end
      end

    end
  end
end

