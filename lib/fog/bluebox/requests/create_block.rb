module Fog
  module Bluebox
    class Real

      # Create a new block
      #
      # ==== Parameters
      # * product_id<~Integer> - Id of product to create block with
      # * template_id<~Integer> - Id of template to create block with
      # * name<~String> - Name of block
      # * options<~Hash>:
      #     * password<~String> - Password for block
      #   or
      #     * ssh_key<~String> - ssh public key
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:
      # TODO
      def create_block(product_id, template_id, name, options = {})
        data = {
          'name'      => name,
          'product'   => product_id,
          'template'  => template_id
        }.merge!(options)

        query = ''
        for key, value in data
          query << "#{key}=#{CGI.escape(value.to_s).gsub(/\+/, '%20')}&"
        end
        query.chop!

        request(
          # :body     => data.to_json,
          :expects  => 200,
          :method   => 'POST',
          :path     => '/api/blocks.json',
          :query    => query
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
