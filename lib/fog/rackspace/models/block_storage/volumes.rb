require 'fog/core/collection'
require 'fog/rackspace/models/block_storage/volume'

module Fog
  module Rackspace
    class BlockStorage
      class Volumes < Fog::Collection
        model Fog::Rackspace::BlockStorage::Volume

        # Returns list of volumes
        # @return [Fog::Rackspace::BlockStorage::Volumes] Retrieves a volumes
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getVolumesSimple__v1__tenant_id__volumes.html
        def all
          data = service.list_volumes.body['volumes']
          load(data)
        end

        # Retrieves volume
        # @param [String] volume_id for snapshot to be returned
        # @return [Fog::Rackspace::BlockStorage::Volume]
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getVolume__v1__tenant_id__volumes.html
        def get(volume_id)
          data = service.get_volume(volume_id).body['volume']
          new(data)
        rescue Fog::Rackspace::BlockStorage::NotFound
          nil
        end
      end
    end
  end
end
