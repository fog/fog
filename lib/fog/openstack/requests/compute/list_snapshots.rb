module Fog
  module Compute
    class OpenStack
      class Real

        def list_snapshots(detailed=true)

          path = detailed ? 'os-snapshots/detail' : 'os-snapshots'
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
