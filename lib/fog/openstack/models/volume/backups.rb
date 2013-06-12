require 'fog/core/collection'
require 'fog/openstack/models/volume/backup'

module Fog
  module Volume
    class OpenStack
      class Backups < Fog::Collection
        
        attribute :filters
        
        model Fog::Volume::OpenStack::Backup

        def initialize(attributes)
          self.filters ||= {}
          super
        end
        
        def all(detailed = true, filters = filters)
          self.filters = filters
          load(service.list_backups(detailed, filters).body['backups'])
        end

        def get(backup_id)
          if backup = service.get_backup_details(backup_id).body['backup']
            new(backup)
          end
        rescue Fog::Volume::OpenStack::NotFound
          nil
        end

      end
    end
  end
end