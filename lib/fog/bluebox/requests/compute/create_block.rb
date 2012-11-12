module Fog
  module Compute
    class Bluebox
      class Real

        # Create a new block
        #
        # ==== Parameters
        # * product_id<~String>   - ID of block product (size)
        # * template_id<~String>  - ID of block OS/build template
        # * location_id<~String>  - ID of deployment location
        # * options<~Hash>:
        #     * password<~String>   - Password for block
        #   or
        #     * public_key<~String> - SSH public key
        #     * username<~String>   - Defaults to deploy
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def create_block(product_id, template_id, location_id, options = {})

          unless options.has_key?('password') || options.has_key?('public_key')
            raise ArgumentError, 'Either password or public_key must be supplied'
          end

          query = {
            'product'  => product_id,
            'template' => template_id,
            'location' => location_id
          }

          request(
            :expects  => 200,
            :method   => 'POST',
            :path     => '/api/blocks.json',
            :query    => query,
            :body     => options.map {|k,v| "#{CGI.escape(k)}=#{CGI.escape(v)}"}.join('&')
          )
        end

      end
    end
  end
end
