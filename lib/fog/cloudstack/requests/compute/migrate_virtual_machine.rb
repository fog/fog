module Fog
  module Compute
    class Cloudstack
      class Real

        # Attempts Migration of a virtual machine to the host specified
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.12/global_admin/migrateVirtualMachine.html]
        def migrate_virtual_machine(options={})
          options.merge!(
            'command' => 'migrateVirtualMachine'
          )

          request(options)
        end

      end
    end
  end
end
