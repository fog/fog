module Fog
  module Compute
    class Bluebox
      class Real

        # Create a new block
        #
        # ==== Parameters
        # * product_id<~String> - ID of product to create block with
        # * template_id<~String> - ID of template to create block with
        # * location_id<~String> - ID of location to create block in
        # * options<~Hash>:
        #     * password<~String> - Password for block
        #   or
        #     * ssh_key<~String> - ssh public key
        #   * username<~String> - optional, defaults to deploy
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def create_block(product_id, template_id, location_id, options = {})

          unless options.has_key?(:password) || options.has_key?(:ssh_key)
            raise ArgumentError, 'Either password or ssh_key must be supplied'
          end

          query = {
            'product'  => product_id,
            'template' => template_id,
            'location' => location_id
          }

          body = URI.encode options.map {|k,v| "#{k}=#{v}"}.join('&')

          request(
            :expects  => 200,
            :method   => 'POST',
            :path     => '/api/blocks.json',
            :query    => query,
            :body     => URI.encode(body)
          )
        end

      end
    end
  end
end
