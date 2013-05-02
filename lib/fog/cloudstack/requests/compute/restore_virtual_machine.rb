  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Restore a VM to original template or specific snapshot
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/restoreVirtualMachine.html]
          def restore_virtual_machine(options={})
            options.merge!(
              'command' => 'restoreVirtualMachine'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
