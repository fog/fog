module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates properties of a virtual machine. The VM has to be stopped and restarted for the new properties to take effect. UpdateVirtualMachine does not first check whether the VM is stopped. Therefore, stop the VM manually before issuing this call.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateVirtualMachine.html]
        def update_virtual_machine(options={})
          options.merge!(
            'command' => 'updateVirtualMachine', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

