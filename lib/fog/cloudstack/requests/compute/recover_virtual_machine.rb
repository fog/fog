module Fog
  module Compute
    class Cloudstack
      class Real

        # Recovers a virtual machine.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/recoverVirtualMachine.html]
        def recover_virtual_machine(options={})
          options.merge!(
            'command' => 'recoverVirtualMachine'
          )

          request(options)
        end

      end
    end
  end
end
