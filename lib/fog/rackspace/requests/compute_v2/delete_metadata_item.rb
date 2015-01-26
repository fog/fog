module Fog
  module Compute
    class RackspaceV2
      class Real
        # Deletes a metadata item.
        # @param [String<images, servers>] collection type of metadata
        # @param [String] obj_id id of the object where the metadata is attached
        # @param [String] key the key of the metadata to delete
        # @return [Excon::Response] response
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/Delete_Metadata_Item-d1e5790.html
        def delete_metadata_item(collection, obj_id, key)
          request(
            :expects => 204,
            :method => 'DELETE',
            :path => "#{collection}/#{obj_id}/metadata/#{key}"
          )
        end
      end

      class Mock
        def delete_metadata_item(collection, obj_id, key)
          raise Fog::Compute::RackspaceV2::NotFound if obj_id == 0

          response = Excon::Response.new
          response.body = ""
          response.status = 204
          response
        end
      end
    end
  end
end
