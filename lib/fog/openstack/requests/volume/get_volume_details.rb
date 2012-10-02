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
              'id'                  => '1',
              'display_name'        => Fog::Mock.random_letters(rand(8) + 5),
              'display_description' => Fog::Mock.random_letters(rand(12) + 10),
              'size'                => 3,
              'volume_type'         => nil,
              'snapshot_id'         => '4',
              'status'              => 'online',
              'availability_zone'   => 'nova',
              'created_at'          => Time.now,
              'attachments'         => []
            }
          }
          response
        end
      end

    end
  end
end
