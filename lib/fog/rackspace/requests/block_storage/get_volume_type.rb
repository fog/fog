module Fog
  module Rackspace
    class BlockStorage
      class Real
        # Retrieves volume type detail
        # @param [String] volume_type_id
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * 'volume_type' [Hash]: -
        #       * 'name' [String]: - name of volume type
        #       * 'extra_specs' [Hash]: -
        #       * 'id' [String]: - id of volume type
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getVolumeType__v1__tenant_id__types.html
        def get_volume_type(volume_type_id)
          request(
            :expects => [200],
            :method => 'GET',
            :path => "types/#{volume_type_id}"
          )
        end
      end

      class Mock
        def get_volume_type(volume_type_id)
          type = self.data[:volume_types][volume_type_id]
          if type.nil?
            raise Fog::Rackspace::BlockStorage::NotFound
          else
            type = type.dup
            type["id"] = type["id"].to_s
            response(:body => {"volume_type" => type})
          end
        end
      end
    end
  end
end
