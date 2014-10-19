module Fog
  module Compute
    class Cloudstack

      class Real
        # Find hosts suitable for migrating a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/findHostsForMigration.html]
        def find_hosts_for_migration(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'findHostsForMigration') 
          else
            options.merge!('command' => 'findHostsForMigration', 
            'virtualmachineid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

