module Fog
  module Compute
    class Bluebox
      class Real

        # Create a template from block
        #
        # ==== Parameters
        # * block_id<~Integer> - Id of block to create template from
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO
        def create_template(block_id, options={})
          request(
            :expects  => 202,
            :method   => 'POST',
            :path     => "api/block_templates.json",
            :query    => {'id' => block_id}.merge!(options)
          )
        end

      end
    end
  end
end
