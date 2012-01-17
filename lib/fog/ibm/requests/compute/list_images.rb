module Fog
  module Compute
    class IBM
      class Real

        # Get available images
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * images<~Array>
        # TODO: docs
        def list_images
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/offerings/image'
          )
        end

      end
    end
  end
end
