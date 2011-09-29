module Fog
  module Compute
    class OpenStack
      class Real

        def list_images
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => 'images.json'
          )
        end

      end

      class Mock

        def list_images
          response = Excon::Response.new
          data = list_images_detail.body['images']
          images = []
          for image in data
            images << image.reject { |key, value| !['id', 'name', 'links'].include?(key) }
          end
          response.status = [200, 203][rand(1)]
          response.body = { 'images' => images }
          response
        end

      end
    end
  end
end
