module Fog
  module Compute
    class DigitalOcean
      class Real
        def list_images(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'images'
          )
        end
      end

      class Mock
        def list_images
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "OK",
            "images" => [
              # Sample image
              {
                "id" => 1601,
                "name" => "CentOS 5.8 x64",
                "distribution" => "CentOS"
              },
              {
                "id" => 1602,
                "name" => "CentOS 5.8 x32",
                "distribution" => "CentOS"
              },
              {
                "id" => 2676,
                "name" => "Ubuntu 12.04 x64",
                "distribution" => "Ubuntu"
              },

            ]
          }
          response
        end
      end
    end
  end
end
