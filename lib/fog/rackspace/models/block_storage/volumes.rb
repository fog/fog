require 'fog/core/collection'
require 'fog/rackspace/models/block_storage/volume'

module Fog
  module Rackspace
    class BlockStorage
      class Volumes < Fog::Collection

        model Fog::Rackspace::BlockStorage::Volume

        def all
          data = connection.list_volumes.body['volumes']
          load(data)
        end

        def get(volume_id)
          data = connection.get_volume(volume_id).body['volume']
          new(data)
        rescue Fog::Rackspace::BlockStorage::NotFound
          nil
        end
      end
    end
  end
end
