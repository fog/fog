module Fog
  module Compute
    class Cloudstack

      class Real
        # Recovers a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/recoverVirtualMachine.html]
        def recover_virtual_machine(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'recoverVirtualMachine') 
          else
            options.merge!('command' => 'recoverVirtualMachine', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

