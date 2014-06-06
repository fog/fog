module Fog
  module Rackspace
    class BlockStorage
      class Real
        # Retrieves list of volume types
        # @return [Excon::Response] response
        #   * body [Hash]:
        #     * 'volume_types' [Array]: -
        #       * 'name' [String]: - name of volume type
        #       * 'extra_specs' [Hash]: -
        #       * 'id' [Fixnum]: - id of volume type
        # @raise [Fog::Rackspace::BlockStorage::NotFound] - HTTP 404
        # @raise [Fog::Rackspace::BlockStorage::BadRequest] - HTTP 400
        # @raise [Fog::Rackspace::BlockStorage::InternalServerError] - HTTP 500
        # @raise [Fog::Rackspace::BlockStorage::ServiceError]
        # @see http://docs.rackspace.com/cbs/api/v1.0/cbs-devguide/content/GET_getVolumeTypes__v1__tenant_id__types.html
        def list_volume_types
          request(
            :expects => [200],
            :method => 'GET',
            :path => 'types'
          )
        end
      end

      class Mock
        def list_volume_types
          types = self.data[:volume_types].values
          response(:body => {"volume_types" => types})
        end
      end
    end
  end
end
