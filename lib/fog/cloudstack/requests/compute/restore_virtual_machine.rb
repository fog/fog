module Fog
  module Compute
    class Cloudstack

      class Real
        # Restore a VM to original template/ISO or new template/ISO
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/restoreVirtualMachine.html]
        def restore_virtual_machine(virtualmachineid, options={})
          options.merge!(
            'command' => 'restoreVirtualMachine', 
            'virtualmachineid' => virtualmachineid  
          )
          request(options)
        end
      end

    end
  end
end

