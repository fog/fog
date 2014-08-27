module Fog
  module Compute
    class Cloudstack

      class Real
        # Reboots a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/rebootVirtualMachine.html]
        def reboot_virtual_machine(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'rebootVirtualMachine') 
          else
            options.merge!('command' => 'rebootVirtualMachine', 
            'id' => args[0])
          end
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

