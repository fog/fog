  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Starts a virtual machine.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/startVirtualMachine.html]
          def start_virtual_machine(options={})
            options.merge!(
              'command' => 'startVirtualMachine'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
