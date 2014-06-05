require 'fog/core/collection'
require 'fog/hp/models/block_storage/volume'

module Fog
  module HP
    class BlockStorage
      class BootableVolumes < Fog::Collection
        model Fog::HP::BlockStorage::Volume

        def all
          data = service.list_bootable_volumes.body['volumes']
          load(data)
        end

        def get(volume_id)
          volume = service.get_bootable_volume_details(volume_id).body['volume']
          new(volume)
        rescue Fog::HP::BlockStorage::NotFound
          nil
        end
      end
    end
  end
end
