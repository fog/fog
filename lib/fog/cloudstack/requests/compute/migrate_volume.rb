module Fog
  module Compute
    class Cloudstack

      class Real
        # Migrate volume
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/migrateVolume.html]
        def migrate_volume(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'migrateVolume') 
          else
            options.merge!('command' => 'migrateVolume', 
            'storageid' => args[0], 
            'volumeid' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

