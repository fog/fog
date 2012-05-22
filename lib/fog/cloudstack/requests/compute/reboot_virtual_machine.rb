module Fog
  module Compute
    class Cloudstack
      class Real

        # Updates account information for the authenticated user.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/rebootVirtualMachine.html]
        def reboot_virtual_machine(options={})
          options.merge!(
            'command' => 'rebootVirtualMachine'
          )

          request(options)
        end

      end

      class Mock
        def reboot_virtual_machine(options={})
          job_id = Fog::Cloudstack.uuid
          {
            "rebootvirtualmachineresponse" => {
              "jobid" => job_id
            }
          }
        end
      end
    end
  end
end
