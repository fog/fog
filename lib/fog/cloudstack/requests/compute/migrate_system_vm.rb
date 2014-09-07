module Fog
  module Compute
    class Cloudstack

      class Real
        # Attempts Migration of a system virtual machine to the host specified.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/migrateSystemVm.html]
        def migrate_system_vm(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'migrateSystemVm') 
          else
            options.merge!('command' => 'migrateSystemVm', 
            'virtualmachineid' => args[0], 
            'hostid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

