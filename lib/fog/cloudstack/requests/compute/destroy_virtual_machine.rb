module Fog
  module Compute
    class Cloudstack
      class Real

        # Updates account information for the authenticated user.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/destroyVirtualMachine.html]
        def destroy_virtual_machine(options={})
          options.merge!(
            'command' => 'destroyVirtualMachine'
          )

          request(options)
        end

      end
    end
  end
end
