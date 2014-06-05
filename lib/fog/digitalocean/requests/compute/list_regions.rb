module Fog
  module Compute
    class DigitalOcean
      class Real
        def list_regions(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'regions'
          )
        end
      end

      class Mock
        def list_regions
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "OK",
            "regions"  => [
              { "id" => 1, "name" => "New York 1" },
              { "id" => 2, "name" => "Amsterdam 1" },
              { "id" => 3, "name" => "San Francisco 1" },
              { "id" => 4, "name" => "New York 2" },
              { "id" => 5, "name" => "Amsterdam 2" },
              { "id" => 6, "name" => "Singapore 1" }
            ]
          }
          response
        end
      end
    end
  end
end
