module Fog
  module Rackspace
    class BlockStorage
      class Real
        # Retrieves volume detail
        # @param [String] volume_id
        # @return [Excon::Response] response:
        #   * body  [Hash]:
        #     * 'volume' [Hash]:
        #       * 'volume_type' [String]: - volume type
        #       * 'display_description' [String]: - volume display description
        #       * 'metadata' [Hash]: - volume metadata
        #       * 'availability_zone' [String]: - region of volume
        #       * 'status' [String]: - status of volume
        #       * 'id' [String]: - id of volume
        #       * 'attachments' [Array<Hash]: - array of hashes containing attachment information
        #       * 'size' [Fixnum]: - size of volume in GB (100 GB minimum)
        #       * 'snapshot_id' [String]: - The optional snapshot from which to create a volume.
        #       * 'os-vol-host-attr:host' [String]: -
        #       * 'display_name' [String]: - display name of volume
        #       * 'created_at' [String]: - the volume creation time
        #       * 'os-vol-tenant-attr:tenant_id' [String]: -
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        #   @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getVolume__v1__tenant_id__volumes.html
        def get_volume(volume_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "volumes/#{volume_id}"
          )
        end
      end

      class Mock
        def get_volume(volume_id)
          possible_states = ["available", "in-use"]
          volume = self.data[:volumes][volume_id]
          if volume.nil?
            raise Fog::Rackspace::BlockStorage::NotFound
          else
            volume["status"] = possible_states[rand(possible_states.length)]
            if volume.nil?
              raise Fog::Rackspace::BlockStorage::NotFound
            else
              response(:body => {"volume" => volume})
            end
          end
        end
      end
    end
  end
end
