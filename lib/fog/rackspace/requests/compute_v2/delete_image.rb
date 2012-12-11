module Fog
  module Compute
    class RackspaceV2
      class Real

        # Delete an image
        #
        # ==== Parameters
        # * image_id<~Integer> - Id of image to delete
        #
        def delete_image(image_id)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "images/#{image_id}"
          )
        end

      end
    end
  end
end
