module Fog
  module Compute
    class Cloudstack

      class Real
        # Returns an encrypted password for the VM
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/getVMPassword.html]
        def get_vm_password(id, options={})
          options.merge!(
            'command' => 'getVMPassword', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

