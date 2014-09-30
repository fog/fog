module Fog
  module Compute
    class RackspaceV2
      class Real
        # Sets a single metadatum item by key.
        # @param [String<images, servers>] collection type of metadata
        # @param [String] obj_id id of the object where the metadata is attached
        # @param [String] key the key of the metadata to set
        # @param [String] value the value of the metadata to set
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * meta [Hash]:
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Create_or_Update_a_Metadata_Item-d1e5633.html
        def set_metadata_item(collection, obj_id, key, value)
          request(
            :expects => 200,
            :method => 'PUT',
            :path => "#{collection}/#{obj_id}/metadata/#{key}",
            :body => Fog::JSON.encode('meta' => { key => value })
          )
        end
      end

      class Mock
        def set_metadata_item(collection, obj_id, key, value)
          raise Fog::Compute::RackspaceV2::NotFound if obj_id == 0

          response = Excon::Response.new
          response.status = 202
          response.body = {"meta" => {key => value}}
          response
        end
      end
    end
  end
end
