module Fog
  module Compute
    class IBM
      class Real

        # Clones image specified by image_id
        #
        # ==== Parameters
        # * image_id<~String> - id of image to be cloned
        # * name<~String> - name of new image
        # * description<~String> - description of new image
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ImageID'<~String>: id of new image
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
      class Mock

        def clone_image(image_id, name, description)
          response = Excon::Response.new
          if image_exists? image_id
            id = Fog::IBM::Mock.instance_id
            self.data[:images][id] = self.data[:images][image_id].merge('id' => id, 'name' => name, 'description' => description)
            response.status = 200
            response.body   = { "ImageID" => id }
          else
            response.status = 404
          end
          response
        end

      end
    end
  end
end
