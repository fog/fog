module Fog
  module Compute
    class OpenStack
      class Real
        def get_snapshot_details(snapshot_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "os-snapshots/#{snapshot_id}"
          )
        end
      end

      class Mock
        def get_snapshot_details(snapshot_id)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'snapshot' => {
              'id'                 => '1',
              'display_name'        => Fog::Mock.random_letters(rand(8) + 5),
              'display_description' => Fog::Mock.random_letters(rand(12) + 10),
              'size'               => 3,
              'volume_id'           => '4',
              'status'             => 'online',
              'created_at'          => Time.now
            }
          }
          response
        end
      end
    end
  end
end
