module Fog
  module Bluebox
    class Real

      require 'fog/bluebox/parsers/get_images'

      # Get list of OS templates
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      #     * 'id'<~String> - UUID of the image
      #     * 'description'<~String> - Description of the image
      #     * 'public'<~Boolean> - Public / Private image
      #     * 'created'<~Datetime> - Timestamp of when the image was created
      def get_images
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Bluebox::GetImages.new,
          :path     => 'api/block_templates.xml'
        )
      end

    end

    class Mock

      def get_images
        Fog::Mock.not_implemented
      end

    end
  end
end
