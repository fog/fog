module Fog
  module Compute
    class Google
      class Mock
        def list_snapshots
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_snapshots
          api_method = @compute.snapshots.list
          parameters = {
            'project' => @project
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
