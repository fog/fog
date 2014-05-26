module Fog
  module Compute
    class DigitalOcean
      class Real
        def list_flavors(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'sizes'
          )
        end
      end

      class Mock
        def list_flavors
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "OK",
            "sizes"  => [
              {"id" => 33,"name" => "512MB"},
              {"id" => 34,"name" => "1GB"},
              {"id" => 35,"name" => "2GB"},
              {"id" => 36,"name" => "4GB"},
              {"id" => 37,"name" => "8GB"},
              {"id" => 38,"name" => "16GB"}
            ]
          }
          response
        end
      end
    end
  end
end
