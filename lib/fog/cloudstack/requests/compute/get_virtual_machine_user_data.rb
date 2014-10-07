module Fog
  module Compute
    class Cloudstack

      class Real
        # Returns user data associated with the VM
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/getVirtualMachineUserData.html]
        def get_virtual_machine_user_data(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'getVirtualMachineUserData') 
          else
            options.merge!('command' => 'getVirtualMachineUserData', 
            'virtualmachineid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

