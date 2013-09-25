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
              {"id" => 1,"name" => "New York 1"},
              {"id" => 2,"name" => "Amsterdam 1"}
            ]
          }
          response
        end

      end
    end
  end
end
