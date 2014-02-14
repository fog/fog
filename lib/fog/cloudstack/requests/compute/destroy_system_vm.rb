  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Destroyes a system virtual machine.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/destroySystemVm.html]
          def destroy_system_vm(options={})
            options.merge!(
              'command' => 'destroySystemVm'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
