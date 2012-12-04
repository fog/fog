require 'fog/core/collection'
require 'fog/hp/models/block_storage/volume'

module Fog
  module BlockStorage
    class HP

      class BootableVolumes < Fog::Collection

        model Fog::BlockStorage::HP::Volume

        def all
          data = connection.list_bootable_volumes.body['volumes']
          load(data)
        end

        def get(volume_id)
          volume = connection.get_bootable_volume_details(volume_id).body['volume']
          new(volume)
        rescue Fog::BlockStorage::HP::NotFound
          nil
        end

      end

    end
  end
end
