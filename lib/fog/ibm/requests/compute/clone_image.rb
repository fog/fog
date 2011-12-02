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
      class Mock

        def clone_image(image_id, name, description)
          response = Excon::Response.new
          if image_exists? image_id
            id = Fog::IBM::Mock.instance_id
            self.data[:images][id] = self.data[:images][image_id].dup
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
