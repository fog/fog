  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Reboots a virtual machine.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/rebootVirtualMachine.html]
          def reboot_virtual_machine(options={})
            options.merge!(
              'command' => 'rebootVirtualMachine'
            )
            request(options)
          end
           
        end # Real

        class Mock
          def reboot_virtual_machine(options={})
            job_id = Fog::Cloudstack.uuid
            {
              "rebootvirtualmachineresponse" => {
                "jobid" => job_id
              }
            }
          end
        end # Mock
      end # Cloudstack
    end # Compute
  end # Fog
