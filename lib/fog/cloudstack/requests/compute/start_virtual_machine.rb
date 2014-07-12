module Fog
  module Compute
    class Cloudstack

      class Real
        # Starts a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/startVirtualMachine.html]
        def start_virtual_machine(id, options={})
          options.merge!(
            'command' => 'startVirtualMachine', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

