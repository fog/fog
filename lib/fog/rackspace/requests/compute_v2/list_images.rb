module Fog
  module Compute
    class RackspaceV2
      class Real
        # Retrieves a list of images
        # ==== Parameters
        # * options<~String>:
        #   * 'name'<~String> - Filters the list of images by image name
        #   * 'limit'<~String> - Maximum number of objects to return
        #   * 'marker'<~String> - Only return objects whose name is greater than marker
        #   * 'status'<~String> - Filters the list of images by status
        #   * 'type'<~String> - Filters base Rackspace images or anyn custom server images that have been created
        #
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
        def list_images(options = {})
          options = options.reject {|key, value| value.nil?}
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => 'images',
            :query => {'format' => 'json'}.merge!(options)
          )
        end
      end

      class Mock
        def list_images(options = {})
          images = self.data[:images].values
          response(:body => {"images" => images})
        end
      end
    end
  end
end
