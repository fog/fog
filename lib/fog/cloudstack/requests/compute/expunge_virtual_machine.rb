module Fog
  module Compute
    class Cloudstack

      class Real
        # Expunge a virtual machine. Once expunged, it cannot be recoverd.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/expungeVirtualMachine.html]
        def expunge_virtual_machine(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'expungeVirtualMachine') 
          else
            options.merge!('command' => 'expungeVirtualMachine', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

