module Fog
  module Compute
    class RackspaceV2
      class Real
              
        # Retrieves a list of snapshot images
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * images [Array]:
        #       * [Hash]:
        #         * id [String] - image id
        #         * links [Array] - image links
        #         * name [String] - image name
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Images-d1e4435.html
      
        def list_snapshot_images
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => 'images?type=SNAPSHOT'
          )
        end
      end
      
      class Mock
        def list_snapshot_images
          images = self.data[:images].values.select {|i| i["metadata"]["image_type"] == "snapshot"}
          response(:body => {"images" => images})
        end
      end
    end
  end
end
