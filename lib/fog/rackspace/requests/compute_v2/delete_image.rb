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
      
      class Mock
        def delete_image(image_id)
          response = Excon::Response.new
          response.status = 202
          response.body = "" 
        end 
        
      end
    end
  end
end
