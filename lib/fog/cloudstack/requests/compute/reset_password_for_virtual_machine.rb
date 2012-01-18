module Fog
  module Compute
    class Cloudstack
      class Real

        # Returns an encrypted password for the VM
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/resetPasswordForVirtualMachine.html]
        def reset_password_for_virtual_machine(id)
          options = {
            'command' => 'resetPasswordForVirtualMachine',
            'id' => id
          }
          
          request(options)
        end

      end
    end
  end
end
