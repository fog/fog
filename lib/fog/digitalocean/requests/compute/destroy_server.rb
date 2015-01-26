module Fog
  module Compute
    class DigitalOcean
      class Real
        #
        # FIXME: missing ssh keys support
        #
        def destroy_server( id )
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "droplets/#{id}/destroy",
            # We scrub data so future users can't read our disks.
            :query    => {:scrub_data => '1' }
          )
        end
      end

      class Mock
        def destroy_server( id )
          response = Excon::Response.new
          response.status = 200
          response.body = {
            "event_id" => Fog::Mock.random_numbers(1).to_i,
            "status" => "OK"
          }

          server = self.data[:servers].reject! { |s| s['id'] == id }

          response
        end
      end
    end
  end
end
