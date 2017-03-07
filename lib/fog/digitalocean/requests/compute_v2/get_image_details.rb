module Fog
  module Compute
    class DigitalOceanV2
      class Real
        def get_image_details(image_id)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "/v2/images/#{image_id}"
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def get_server_details(_)
          response        = Excon::Response.new
          response.status = 200

          response.body = {
            'image' =>
            {
              'id' => 7555620,
              'name' => 'Nifty New Snapshot',
              'distribution' => 'Ubuntu',
              'slug' => null,
              'public' => false,
              'regions' => [
                'nyc2',
                'nyc2'
                ],
                'created_at' => '2014-11-04T22:23:02Z',
                'min_disk_size' => 20
              }
            }

          response
        end
      end
    end
  end
end
