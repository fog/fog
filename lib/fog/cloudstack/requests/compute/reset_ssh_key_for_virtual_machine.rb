module Fog
  module Compute
    class Cloudstack

      class Real
        # Resets the SSH Key for virtual machine. The virtual machine must be in a "Stopped" state. [async]
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/resetSSHKeyForVirtualMachine.html]
        def reset_ssh_key_for_virtual_machine(options={})
          options.merge!(
            'command' => 'resetSSHKeyForVirtualMachine', 
            'id' => options['id'], 
            'keypair' => options['keypair']  
          )
          request(options)
        end
      end

    end
  end
end

