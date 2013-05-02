  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Reboots a system VM.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/rebootSystemVm.html]
          def reboot_system_vm(options={})
            options.merge!(
              'command' => 'rebootSystemVm'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
