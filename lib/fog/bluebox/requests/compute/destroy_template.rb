module Fog
  module Compute
    class Bluebox
      class Real
        # Create a template from block
        #
        # ==== Parameters
        # * id<~Integer> - Id of image to destroy
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        # TODO
        def destroy_template(id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "api/block_templates/#{id}.json"
          )
        end
      end
    end
  end
end
