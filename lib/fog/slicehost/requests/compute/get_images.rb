module Fog
  module Compute
    class Slicehost
      class Real

        require 'fog/slicehost/parsers/compute/get_images'

        # Get list of images
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'id'<~Integer> - Id of the image
        #     * 'name'<~String> - Name of the image
        def get_images
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Compute::Slicehost::GetImages.new,
            :path     => 'images.xml'
          )
        end

      end
    end
  end
end
