module Fog
  module Compute
    class BareMetalCloud
      class Real

        # List images
        #
        # ==== Parameters
        # * options<~Hash>: Optional or Required arguments
        #   * no parameters are required
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'image'<~Array>        
        #       * 'Size'<~String>  - Size of the image
        #       * 'Name'<~String>  - Name of the image
        #
        def list_images(options = {})
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/listImages',
            :query    => options
          )
        end

      end
    end
  end
end
