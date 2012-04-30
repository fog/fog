module Fog
  module Volume
    class OpenStack
      class Real

        def delete_snapshot(snapshot_id)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "snapshots/#{snapshot_id}"
          )
        end

      end

      class Mock
        def delete_snapshot(snapshot_id)
          response = Excon::Response.new
          response.status = 204
          response
        end
      end

    end
  end
end
