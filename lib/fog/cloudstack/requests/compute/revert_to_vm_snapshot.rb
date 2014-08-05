module Fog
  module Compute
    class Cloudstack

      class Real
        # Revert VM from a vmsnapshot.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/revertToVMSnapshot.html]
        def revert_to_vm_snapshot(vmsnapshotid, options={})
          options.merge!(
            'command' => 'revertToVMSnapshot', 
            'vmsnapshotid' => vmsnapshotid  
          )
          request(options)
        end
      end

    end
  end
end

