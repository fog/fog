  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Migrate volume
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/migrateVolume.html]
          def migrate_volume(options={})
            options.merge!(
              'command' => 'migrateVolume'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
