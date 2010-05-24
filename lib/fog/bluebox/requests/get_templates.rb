module Fog
  module Bluebox
    class Real

      require 'fog/bluebox/parsers/get_templates'

      # Get list of OS templates
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Array>:
      #     * 'id'<~String> - UUID of the image
      #     * 'description'<~String> - Description of the image
      #     * 'public'<~Boolean> - Public / Private image
      #     * 'created'<~Datetime> - Timestamp of when the image was created
      def get_templates
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Bluebox::GetTemplates.new,
          :path     => 'api/block_templates.xml'
        )
      end

    end

    class Mock

      def get_images
        raise MockNotImplemented.new("Contributions welcome!")
      end

    end
  end
end
