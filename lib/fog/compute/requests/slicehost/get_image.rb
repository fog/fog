module Fog
  module Slicehost
    class Compute
      class Real

        require 'fog/compute/parsers/slicehost/get_image'

        # Get details of an image
        #
        # ==== Parameters
        # * image_id<~Integer> - Id of image to lookup
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'id'<~Integer> - Id of the image
        #     * 'name'<~String> - Name of the image
        def get_image(image_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser   => Fog::Parsers::Slicehost::Compute::GetImage.new,
            :path     => "images/#{image_id}.xml"
          )
        end

      end
    end
  end
end
