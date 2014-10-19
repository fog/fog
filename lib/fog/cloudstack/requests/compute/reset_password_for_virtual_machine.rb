module Fog
  module Compute
    class Cloudstack

      class Real
        # Resets the password for virtual machine. The virtual machine must be in a "Stopped" state and the template must already support this feature for this command to take effect. [async]
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/resetPasswordForVirtualMachine.html]
        def reset_password_for_virtual_machine(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'resetPasswordForVirtualMachine') 
          else
            options.merge!('command' => 'resetPasswordForVirtualMachine', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

