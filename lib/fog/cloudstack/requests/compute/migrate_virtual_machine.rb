  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Attempts Migration of a VM to a different host or Root volume of the vm to a different storage pool
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/migrateVirtualMachine.html]
          def migrate_virtual_machine(options={})
            options.merge!(
              'command' => 'migrateVirtualMachine'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
