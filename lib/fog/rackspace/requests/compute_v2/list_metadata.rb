module Fog
  module Compute
    class RackspaceV2
      class Real
        # Retrieves all metadata associated with a server or an image.
        # @param [String<images, servers>] collection type of metadata
        # @param [String] obj_id id of the object where the metadata is attached
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * meta [Hash]:
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Metadata-d1e5089.html
        def list_metadata(collection, obj_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "#{collection}/#{obj_id}/metadata"
          )
        end
      end

      class Mock
        def list_metadata(collection, obj_id)
          raise Fog::Compute::RackspaceV2::NotFound if obj_id == 0

          response = Excon::Response.new
          response.status = 202
          response.body = { "metadata"=>{"tag"=>"database"} }
          response
        end
      end
    end
  end
end
