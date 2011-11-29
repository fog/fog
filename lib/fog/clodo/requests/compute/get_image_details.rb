module Fog
  module Compute
    class Clodo
      class Real
        def get_image_details(image_id)
          request(:expects => [200,203],
                  :method => 'GET',
                  :path => "images/#{image_id}")
        end
      end
      class Mock
        def get_image_details(image_id)
          response = Excon::Response.new
          response.status = 404
          response
        end
      end
    end
  end
end
