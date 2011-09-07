module Fog
  module Compute
    class Cloudstack
      class Real

        # Returns an encrypted password for the VM
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/getVMPassword.html]
        def get_vm_password(id)
          options = {
            'command' => 'getVMPassword',
            'id' => id
          }
          
          request(options)
        end

      end
    end
  end
end
