module Fog
  module Compute
    class IBM
      class Real

        # Delete an image
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
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
