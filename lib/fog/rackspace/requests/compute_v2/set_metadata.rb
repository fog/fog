module Fog
  module Compute
    class RackspaceV2
      class Real
        # Sets metadata associated with a server or an image.
        # @param [String<images, servers>] collection type of metadata
        # @param [String] obj_id id of the object where the metadata is attached
        # @param [Hash] metadata key value pairs of metadata
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * metadata [Hash]:
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Create_or_Replace_Metadata-d1e5358.html
        def set_metadata(collection, obj_id, metadata = {})
          request(
            :expects => [200, 203],
            :method => 'PUT',
            :path => "#{collection}/#{obj_id}/metadata",
            :body => Fog::JSON.encode('metadata' => metadata)
          )
        end
      end

      class Mock
        def set_metadata(collection, obj_id, metadata = {})
          raise Fog::Compute::RackspaceV2::NotFound if obj_id == 0

          response = Excon::Response.new
          response.status = 202
          response.body = {"metadata"=>{"environment"=>"dev"}}
          response
        end
      end
    end
  end
end
