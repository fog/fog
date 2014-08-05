module Fog
  module Compute
    class Cloudstack

      class Real
        # Recovers a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/recoverVirtualMachine.html]
        def recover_virtual_machine(id, options={})
          options.merge!(
            'command' => 'recoverVirtualMachine', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

