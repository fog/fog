module Fog
  module Compute
    class Cloudstack
      class Real

        # Changes the service offering for a virtual machine. The virtual machine must be in a "Stopped" state for this command to take effect.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.12/global_admin/changeServiceForVirtualMachine.html]
        def change_service_for_virtual_machine(options={})
          options.merge!(
            'command' => 'changeServiceForVirtualMachine'
          )

          request(options)
        end

      end
    end
  end
end
