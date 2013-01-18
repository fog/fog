module Fog
  module Compute
    class RackspaceV2
      class Real
        def get_image(image_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "images/#{image_id}"
          )
        end
      end

      class Mock
        def get_image(image_id)
          image = self.data[:images][image_id]
          if image.nil?
            raise Fog::Compute::RackspaceV2::NotFound
          else
            response(:body => {"image" => image})
          end
        end
      end
    end
  end
end
