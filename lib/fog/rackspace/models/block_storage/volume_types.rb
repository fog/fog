require 'fog/core/collection'
require 'fog/rackspace/models/block_storage/volume_type'

module Fog
  module Rackspace
    class BlockStorage
      class VolumeTypes < Fog::Collection

        model Fog::Rackspace::BlockStorage::VolumeType

        def all
          data = connection.list_volume_types.body['volume_types']
          load(data)
        end

        def get(volume_type_id)
          data = connection.get_volume_type(volume_type_id).body['volume_type']
          new(data)
        rescue Fog::Rackspace::BlockStorage::NotFound
          nil
        end   
      end
    end
  end
end
