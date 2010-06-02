module Fog
  module Bluebox
    class Real

      require 'fog/bluebox/parsers/create_block'

      # Create a new block
      #
      # ==== Parameters
      # * flavor_id<~Integer> - Id of flavor to create block with
      # * image_id<~Integer> - Id of template to create block with
      # * name<~String> - Name of block
      # * password<~String> - Password for block
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      # TODO
      def create_block(flavor_id, image_id, name, password)
        data =
<<-DATA
<?xml version="1.0" encoding="UTF-8"?>
<block>
  <name>#{name}</name>
  <password>#{password}</password>
  <product type="string">#{flavor_id}</product>
  <template type="string">#{image_id}</template>
</block>
DATA

        request(
          :body     => data,
          :expects  => 200,
          :method   => 'POST',
          :parser   => Fog::Parsers::Bluebox::CreateBlock.new,
          :path     => '/api/blocks.xml'
        )
      end

    end

    class Mock

      def create_block(flavor_id, image_id, name, password)
        Fog::Mock.not_implemented
      end

    end
  end
end
