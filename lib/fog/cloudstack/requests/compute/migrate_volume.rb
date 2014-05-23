module Fog
  module Compute
    class Cloudstack

      class Real
        # Migrate volume
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/migrateVolume.html]
        def migrate_volume(options={})
          options.merge!(
            'command' => 'migrateVolume',
            'volumeid' => options['volumeid'], 
            'storageid' => options['storageid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

