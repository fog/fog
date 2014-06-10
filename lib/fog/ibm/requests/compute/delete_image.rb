module Fog
  module Compute
    class IBM
      class Real
        # Deletes the image that the authenticated user manages with the specified :image_id
        #
        # ==== Parameters
        # * image_id<~String> - Id of image
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     *'success'<~Bool>: true or false for success
        def delete_image(image_id)
          request(
            :method   => 'DELETE',
            :expects  => 200,
            :path     => "/offerings/image/#{image_id}"
          )
        end
      end
      class Mock
        def delete_image(image_id)
          response = Excon::Response.new
          # TODO: We should probably check that an image is deleteable.
          # i.e. that the user has appropriate permissions
          if image_exists? image_id
            self.data[:images].delete image_id
            response.status = 200
            response.body = {"success"=>true}
          else
            response.status = 404
          end
          response
        end
      end
    end
  end
end
