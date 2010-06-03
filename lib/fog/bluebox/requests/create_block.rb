module Fog
  module Bluebox
    class Real

      # Create a new block
      #
      # ==== Parameters
      # * product_id<~Integer> - Id of product to create block with
      # * template_id<~Integer> - Id of template to create block with
      # * name<~String> - Name of block
      # * password<~String> - Password for block
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      # TODO
      def create_block(product_id, template_id, name, password)
        data = {
          'name'      => name,
          'password'  => password,
          'product'   => product_id,
          'template'  => template_id
        }

        request(
          :body     => data.to_json,
          :expects  => 200,
          :method   => 'POST',
          :path     => '/api/blocks.json'
        )
      end

    end

    class Mock

      def create_block(product_id, template_id, name, password)
        Fog::Mock.not_implemented
      end

    end
  end
end
