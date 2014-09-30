module Fog
  module Compute
    class Cloudstack

      class Real
        # Attempts Migration of a VM with its volumes to a different host
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/migrateVirtualMachineWithVolume.html]
        def migrate_virtual_machine_with_volume(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'migrateVirtualMachineWithVolume') 
          else
            options.merge!('command' => 'migrateVirtualMachineWithVolume', 
            'hostid' => args[0], 
            'virtualmachineid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

