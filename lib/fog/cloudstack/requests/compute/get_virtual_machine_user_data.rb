module Fog
  module Compute
    class Cloudstack

      class Real
        # Returns user data associated with the VM
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/getVirtualMachineUserData.html]
        def get_virtual_machine_user_data(options={})
          request(options)
        end


        def get_virtual_machine_user_data(virtualmachineid, options={})
          options.merge!(
            'command' => 'getVirtualMachineUserData', 
            'virtualmachineid' => virtualmachineid  
          )
          request(options)
        end
      end

    end
  end
end

