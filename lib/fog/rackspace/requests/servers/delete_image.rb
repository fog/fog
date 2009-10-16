unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

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

else

  module Fog
    module Rackspace
      class Servers

        def delete_image
        end

      end
    end
  end

end
