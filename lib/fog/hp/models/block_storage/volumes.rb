require 'fog/core/collection'
require 'fog/hp/models/block_storage/volume'

module Fog
  module BlockStorage
    class HP

      class Volumes < Fog::Collection

        model Fog::BlockStorage::HP::Volume

        def all
          data = connection.list_volumes.body['volumes']
          load(data)
        end

        def get(volume_id)
          if volume = connection.get_volume_details(volume_id).body['volume']
            new(volume)
          end
        rescue Fog::BlockStorage::HP::NotFound
          nil
        end

      end

    end
  end
end
