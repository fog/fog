module Fog
  module Volume
    class OpenStack
      class Real

        def get_volume_details(volume_id)

          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "volumes/#{volume_id}"
          )
        end

      end

      class Mock

        def get_volume_details(detailed=true)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'volume' => {
              'id'                 => '1',
              'displayName'        => Fog::Mock.random_letters(rand(8) + 5),
              'displayDescription' => Fog::Mock.random_letters(rand(12) + 10),
              'size'               => 3,
              'volumeType'         => nil,
              'snapshotId'         => '4',
              'status'             => 'online',
              'availabilityZone'   => 'nova',
              'createdAt'          => Time.now,
              'attchments'         => []
            }
          }
          response
        end
      end

    end
  end
end
