module Fog
  module Image
    class OpenStack
      class Real

        def delete_image(image_id)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "images/#{image_id}"
          )
        end

      end

      class Mock
        def delete_image(image_id)
          response = Excon::Response.new
          response.status = 200
          response
        end
      end
    end
  end
end
