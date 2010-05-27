module Fog
  module Slicehost
    class Real

      require 'fog/slicehost/parsers/get_images'

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
          :parser   => Fog::Parsers::Slicehost::GetImages.new,
          :path     => 'images.xml'
        )
      end

    end

    class Mock

      def get_images
        raise Fog::Errors::MockNotImplemented.new("Contributions welcome!")
      end

    end
  end
end
