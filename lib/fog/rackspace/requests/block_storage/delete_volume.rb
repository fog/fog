module Fog
  module Rackspace
    class BlockStorage
      class Real
        # Delete volume
        #
        # @param [String] volume_id Id of volume to delete
        # @return [Excon::Response] response
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @note You cannot delete a volume until all of its dependent snaphosts have been deleted.
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/DELETE_deleteVolume__v1__tenant_id__volumes.html
        def delete_volume(volume_id)
          request(
            :expects => [202],
            :method => 'DELETE',
            :path => "volumes/#{volume_id}"
          )
        end
      end

      class Mock
        def delete_volume(volume_id)
          volume = self.data[:volumes][volume_id]
          snapshots = self.data[:snapshots].values.select { |s| s["volume_id"] == volume_id }
          raise Fog::Rackspace::BlockStorage::BadRequest.new("Volume still has #{snapshots.count} dependent snapshots") if !snapshots.empty?
          unless volume.nil?
            unless volume["attachments"].empty?
              raise Fog::Rackspace::BlockStorage::BadRequest.new("Volume status must be available or error")
            end
            self.data[:volumes].delete(volume_id)
            response(:status => 202)
          else
            raise Fog::Rackspace::BlockStorage::NotFound
          end
        end
      end
    end
  end
end
