module Fog
  module Volume
    class OpenStack
      class Real
        def list_snapshots(detailed=true)
          path = detailed ? 'snapshots/detail' : 'snapshots'
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => path
          )
        end
      end

      class Mock
        def list_snapshots(detailed=true)
          response = Excon::Response.new
          response.status = 200
          response.body = {
            'snapshots' => [get_snapshot_details.body["snapshot"]]
          }
          response
        end
      end
    end
  end
end
