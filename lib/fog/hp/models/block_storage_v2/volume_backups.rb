require 'fog/core/collection'
require 'fog/hp/models/block_storage_v2/volume_backup'

module Fog
  module HP
    class BlockStorageV2
      class VolumeBackups < Fog::Collection
        attribute :filters

        model Fog::HP::BlockStorageV2::VolumeBackup

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          details = filters_arg.delete(:details)
          self.filters = filters_arg
          non_aliased_filters = Fog::HP.convert_aliased_attributes_to_original(self.model, filters)
          if details
            data = service.list_volume_backups_detail(non_aliased_filters).body['backups']
          else
            data = service.list_volume_backups(non_aliased_filters).body['backups']
          end
          load(data)
        end

        def get(backup_id)
          backup = service.get_volume_backup_details(backup_id).body['backup']
          new(backup)
        rescue Fog::HP::BlockStorageV2::NotFound
          nil
        end
      end
    end
  end
end
