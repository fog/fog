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
        def get_image(image_id)
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => "/offerings/image/#{image_id}"
          )
        end

      end

      class Mock

        def get_image(image_id)
          response = Excon::Response.new
          if image_exists? image_id
            response.status = 200
            response.body = self.data[:images][image_id]
          else
            response.status = 404
          end
          response
        end

        private

        def image_exists?(image_id)
          self.data[:images].key? image_id
        end

      end
    end
  end
end
