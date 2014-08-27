module Fog
  module Compute
    class Cloudstack

      class Real
        # Destroyes a system virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/destroySystemVm.html]
        def destroy_system_vm(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'destroySystemVm') 
          else
            options.merge!('command' => 'destroySystemVm', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

