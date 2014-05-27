module Fog
  module Compute
    class Cloudstack

      class Real
        # Attempts Migration of a VM with its volumes to a different host
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/migrateVirtualMachineWithVolume.html]
        def migrate_virtual_machine_with_volume(options={})
          options.merge!(
            'command' => 'migrateVirtualMachineWithVolume', 
            'hostid' => options['hostid'], 
            'virtualmachineid' => options['virtualmachineid']  
          )
          request(options)
        end
      end

    end
  end
end

