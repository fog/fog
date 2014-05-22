module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists storage pools available for migration of a volume.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/findStoragePoolsForMigration.html]
        def find_storage_pools_for_migration(options={})
          options.merge!(
            'command' => 'findStoragePoolsForMigration',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

