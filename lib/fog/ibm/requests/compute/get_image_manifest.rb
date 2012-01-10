module Fog
  module Compute
    class IBM
      class Real

        # Get an image manifest
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def get_image_manifest(image_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/offerings/image/#{image_id}/manifest"
          )
        end

      end
    end
  end
end
