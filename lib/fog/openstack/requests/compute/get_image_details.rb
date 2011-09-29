module Fog
  module Compute
    class OpenStack
      class Real

        def get_image_details(image_id)
          request(
            :expects  => [200, 203],
            :method   => 'GET',
            :path     => "images/#{image_id}.json"
          )
        end

      end

      class Mock

        def get_image_details(image_id)
          response = Excon::Response.new
          if image = list_images_detail.body['images'].detect {|_| _['id'] == image_id}
            response.status = [200, 203][rand(1)]
            response.body = { 'image' => image }
            response
          else
            raise Fog::Compute::OpenStack::NotFound
          end
        end

      end

    end
  end
end
