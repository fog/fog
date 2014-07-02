module Fog
  module Compute
    class Cloudstack

      class Real
        # Attempts Migration of a VM to a different host or Root volume of the vm to a different storage pool
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/migrateVirtualMachine.html]
        def migrate_virtual_machine(virtualmachineid, options={})
          options.merge!(
            'command' => 'migrateVirtualMachine', 
            'virtualmachineid' => virtualmachineid  
          )
          request(options)
        end
      end

    end
  end
end

