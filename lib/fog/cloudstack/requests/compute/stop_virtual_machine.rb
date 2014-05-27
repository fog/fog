module Fog
  module Compute
    class Cloudstack

      class Real
        # Stops a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/stopVirtualMachine.html]
        def stop_virtual_machine(options={})
          options.merge!(
            'command' => 'stopVirtualMachine', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

