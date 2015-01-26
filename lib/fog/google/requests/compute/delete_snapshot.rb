module Fog
  module Compute
    class Google
      class Mock
        def delete_snapshot(snapshot_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_snapshot(snapshot_name)
          api_method = @compute.snapshots.delete
          parameters = {
            'project' => @project,
            'snapshot' => snapshot_name,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
