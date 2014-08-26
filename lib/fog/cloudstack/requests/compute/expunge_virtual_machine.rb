module Fog
  module Compute
    class Cloudstack

      class Real
        # Expunge a virtual machine. Once expunged, it cannot be recoverd.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/expungeVirtualMachine.html]
        def expunge_virtual_machine(options={})
          request(options)
        end


        def expunge_virtual_machine(id, options={})
          options.merge!(
            'command' => 'expungeVirtualMachine', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

