  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Recovers a virtual machine.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/recoverVirtualMachine.html]
          def recover_virtual_machine(options={})
            options.merge!(
              'command' => 'recoverVirtualMachine'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
