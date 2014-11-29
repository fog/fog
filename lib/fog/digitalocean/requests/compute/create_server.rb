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
            options[:ssh_key_ids]    = options[:ssh_key_ids].join(",") if options[:ssh_key_ids].is_a? Array
            query_hash[:ssh_key_ids] = options[:ssh_key_ids]
          end

          query_hash[:private_networking] = !!options[:private_networking]
          # backups are enabled using backups_enabled query parameter!
          query_hash[:backups_enabled] = !!options[:backups_active]

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

          # New York 2 (region id 4) is currently the only region that supports
          # private networking.  The Digital Ocean IP will return a null
          # private_ip_address for any other region
          has_private_ip = !!options[:private_networking] && (region_id == 4)

          mock_data = {
            "id" => Fog::Mock.random_numbers(1).to_i,
            "event_id" => Fog::Mock.random_numbers(2).to_i,
            "name" => name,
            "size_id" => size_id,
            "image_id" => image_id,
            "region_id" => region_id,
            "ip_address" => "127.0.0.1",
            "private_ip_address" => has_private_ip ? "10.0.0.1" : nil,
            "status" => 'active',
            "created_at" => Time.now.strftime("%FT%TZ")
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
