module Fog
  module Compute
    class IBM
      class Real

        # Get an image
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def get_image_agreement(image_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/offerings/image/#{image_id}/agreement"
          )
        end

      end
    end
  end
end
