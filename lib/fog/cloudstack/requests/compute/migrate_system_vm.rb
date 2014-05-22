module Fog
  module Compute
    class Cloudstack

      class Real
        # Attempts Migration of a system virtual machine to the host specified.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/migrateSystemVm.html]
        def migrate_system_vm(options={})
          options.merge!(
            'command' => 'migrateSystemVm',
            'hostid' => options['hostid'], 
            'virtualmachineid' => options['virtualmachineid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

