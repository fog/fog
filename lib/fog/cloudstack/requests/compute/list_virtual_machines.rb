module Fog
  module Compute
    class Cloudstack
      class Real

        # List the virtual machines owned by the account.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listVirtualMachines.html]
        def list_virtual_machines(options={})
          options.merge!(
            'command' => 'listVirtualMachines'
          )
          
          request(options)
        end

      end
    end
  end
end
