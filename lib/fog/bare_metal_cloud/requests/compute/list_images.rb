module Fog
  module Compute
    class BareMetalCloud
      class Real
        # List images
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'image'<~Array>
        #       * 'Size'<~String>  - Size of the image
        #       * 'Name'<~String>  - Name of the image
        #
        def list_images
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::ToHashDocument.new,
            :path     => 'api/listImages'
          )
        end
      end
    end
  end
end
