module Fog
  module Compute
    class DigitalOcean
      class Real

        #
        # FIXME: missing ssh keys support
        #
        def create_server( name, 
                           size_id, 
                           image_id, 
                           region_id,
                           options = {} )

          query_hash = {
            :name        => name,
            :size_id     => size_id,
            :image_id    => image_id,
            :region_id   => region_id
          }

          if options[:ssh_key_ids]
            query_hash[:ssh_key_ids] = options[:ssh_key_ids]
          end
          
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'droplets/new',
            :query    => query_hash
          )
        end

      end

      class Mock

        def create_server( name, 
                           size_id, 
                           image_id, 
                           region_id,
                           options = {} )
          response = Excon::Response.new
          response.status = 200

          mock_data = {
            "id" => Fog::Mock.random_numbers(1).to_i,
            "event_id" => Fog::Mock.random_numbers(2).to_i,
            "name" => name,
            "size_id" => size_id,
            "image_id" => image_id,
            "region_id" => region_id,
            "status" => 'active'
          }

          response.body = {
            "status" => "OK",
            "droplet"  => mock_data
          }

          self.data[:servers] << mock_data
          response
        end

      end
    end
  end
end
