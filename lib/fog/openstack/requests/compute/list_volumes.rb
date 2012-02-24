module Fog
  module Compute
    class OpenStack
      class Real

        def list_volumes(detailed=true)

          path = detailed ? 'os-volumes/detail' : 'os-volumes'
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => path
          )
        end

      end

      class Mock

        def list_volumes(detailed=true)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'volumes' => [
              { 'id'                 => '1',
                'displayName'        => Fog::Mock.random_letters(rand(8) + 5),
                'displayDescription' => Fog::Mock.random_letters(rand(12) + 10),
                'size'               => 3,
                'status'             => 'online',
                'snapshotId'         => '4',
                'volumeType'         => nil,
                'availabilityZone'   => 'nova',
                'createdAt'          => Time.now,
                'attchments'         => []}
            ]
          }
          response
        end
      end

    end
  end
end
