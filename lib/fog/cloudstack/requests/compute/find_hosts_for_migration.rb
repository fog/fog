module Fog
  module Compute
    class Cloudstack

      class Real
        # Find hosts suitable for migrating a virtual machine.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/findHostsForMigration.html]
        def find_hosts_for_migration(options={})
          options.merge!(
            'command' => 'findHostsForMigration', 
            'virtualmachineid' => options['virtualmachineid']  
          )
          request(options)
        end
      end

    end
  end
end

