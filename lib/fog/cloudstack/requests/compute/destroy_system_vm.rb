module Fog
  module Compute
    class Cloudstack

      class Real
        # Destroyes a system virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/destroySystemVm.html]
        def destroy_system_vm(options={})
          options.merge!(
            'command' => 'destroySystemVm',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

