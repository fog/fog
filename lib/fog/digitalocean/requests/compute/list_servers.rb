module Fog
  module Compute
    class DigitalOcean 
      class Real

        def list_servers(options = {})
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'droplets'
          )
        end

      end

      class Mock

        def list_servers
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "OK",
            "droplets"  => [
              # Sample droplet
              #{ 
              #  "backups_active" => nil,
              #  "id"             => 100823,
              #  "image_id"       => 420,
              #  "name"           => "test222",
              #  "region_id"      => 1,
              #  "size_id"        => 33,
              #  "status"         => "active"
              #}
            ]
          }
          response
        end

      end
    end
  end
end
