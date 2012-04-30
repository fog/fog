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

        def get_snapshot_details(detailed=true)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'snapshot' => {
              'id'                 => '1',
              'displayName'        => Fog::Mock.random_letters(rand(8) + 5),
              'displayDescription' => Fog::Mock.random_letters(rand(12) + 10),
              'size'               => 3,
              'volumeId'           => '4',
              'status'             => 'online',
              'createdAt'          => Time.now
            }
          }
          response
        end
      end

    end
  end
end
