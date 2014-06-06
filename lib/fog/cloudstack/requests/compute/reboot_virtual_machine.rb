module Fog
  module Compute
    class Cloudstack

      class Real
        # Reboots a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/rebootVirtualMachine.html]
        def reboot_virtual_machine(id, options={})
          options.merge!(
            'command' => 'rebootVirtualMachine', 
            'id' => id  
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

