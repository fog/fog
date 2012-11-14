require 'fog/core/collection'
require 'fog/hp/models/block_storage/volume'

module Fog
  module BlockStorage
    class HP

      class Volumes < Fog::Collection

        model Fog::BlockStorage::HP::Volume

        def all(options={})
          if @bootable = options[:only_bootable]
            data = connection.list_bootable_volumes.body['volumes']
          else
            data = connection.list_volumes.body['volumes']
          end
          load(data)
        end

        def get(volume_id)
          if @bootable
            volume = connection.get_bootable_volume_details(volume_id).body['volume']
          else
            volume = connection.get_volume_details(volume_id).body['volume']
          end
          new(volume)
        rescue Fog::BlockStorage::HP::NotFound
          nil
        end

      end

    end
  end
end
