module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a vmsnapshot.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteVMSnapshot.html]
        def delete_vm_snapshot(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteVMSnapshot') 
          else
            options.merge!('command' => 'deleteVMSnapshot', 
            'vmsnapshotid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

