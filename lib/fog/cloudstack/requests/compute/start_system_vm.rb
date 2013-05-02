  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Starts a system virtual machine.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/startSystemVm.html]
          def start_system_vm(options={})
            options.merge!(
              'command' => 'startSystemVm'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
