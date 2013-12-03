module Fog
  module Volume 
    class OpenStack
      class Real

        def get_snapshot_details(snapshot_id)

          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "snapshots/#{snapshot_id}"
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
              'display_name'        => 'Snapshot1',
              'display_description' => 'Volume1 snapshot',
              'size'               => 1,
              'volume_id'           => '1',
              'status'             => 'available',
              'created_at'          => Time.now
            }
          }
          response
        end
      end

    end
  end
end
