module Fog
  module Compute
    class RackspaceV2
      class Real
        
        # Retrieves a list of images
        # @return [Excon::Response] response:
        #   * body [Hash]:
        #     * images [Array]:
        #       * [Hash]:
        #         * id [String] - flavor id
        #         * links [Array] - image links
        #         * name [String] - image name
        # @raise [Fog::Compute::RackspaceV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::RackspaceV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::RackspaceV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::RackspaceV2::ServiceError]
        # @see http://docs.rackspace.com/servers/api/v2/cs-devguide/content/List_Flavors-d1e4188.html        
        def list_images
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => 'images'
          )
        end
      end

      class Mock
        def list_images
          images = self.data[:images].values
          response(:body => {"images" => images})
        end
      end
    end
  end
end
