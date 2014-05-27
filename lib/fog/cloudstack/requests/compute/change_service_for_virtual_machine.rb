module Fog
  module Compute
    class Cloudstack

      class Real
        # Changes the service offering for a virtual machine. The virtual machine must be in a "Stopped" state for this command to take effect.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/changeServiceForVirtualMachine.html]
        def change_service_for_virtual_machine(options={})
          options.merge!(
            'command' => 'changeServiceForVirtualMachine', 
            'id' => options['id'], 
            'serviceofferingid' => options['serviceofferingid']  
          )
          request(options)
        end
      end

    end
  end
end

