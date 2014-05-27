module Fog
  module Compute
    class Cloudstack

      class Real
        # Scales the virtual machine to a new service offering.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/scaleVirtualMachine.html]
        def scale_virtual_machine(options={})
          options.merge!(
            'command' => 'scaleVirtualMachine', 
            'id' => options['id'], 
            'serviceofferingid' => options['serviceofferingid']  
          )
          request(options)
        end
      end

    end
  end
end

