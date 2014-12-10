require 'fog/core/collection'
require 'fog/rackspace/models/block_storage/volume_type'

module Fog
  module Rackspace
    class BlockStorage
      class VolumeTypes < Fog::Collection
        model Fog::Rackspace::BlockStorage::VolumeType

        # Returns list of volume types
        # @return [Fog::Rackspace::BlockStorage::VolumeTypes] Retrieves a list volume types.
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getVolumeTypes__v1__tenant_id__types.html
        def all
          data = service.list_volume_types.body['volume_types']
          load(data)
        end

        # Retrieves volume type
        # @param [String] volume_type_id for volume_type to be returned
        # @return [Fog::Rackspace::BlockStorage::VolumeType]
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getVolumeType__v1__tenant_id__types.html
        def get(volume_type_id)
          data = service.get_volume_type(volume_type_id).body['volume_type']
          new(data)
        rescue Fog::Rackspace::BlockStorage::NotFound
          nil
        end
      end
    end
  end
end
