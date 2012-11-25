module Fog
  module Compute
    class RackspaceV2
      class Real
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
          response.status = 204
          response
        end

      end
    end
  end
end
