module Fog
  module Compute
    class IBM
      class Real

        # Clone an image
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def clone_image(image_id, name, description)
          request(
            :method   => 'POST',
            :expects  => 200,
            :path     => "/offerings/image/#{image_id}",
            :body     => {
              'name' => name,
              'description' => description
            }
          )
        end

      end
    end
  end
end
