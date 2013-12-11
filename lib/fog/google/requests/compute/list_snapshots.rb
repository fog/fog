module Fog
  module Compute
    class Google

      class Mock

        def list_snapshots
          Fog::Mock.not_implemented
        end

      end

      class Real

        def list_snapshots(project=nil)
          api_method = @compute.snapshots.list
          project=@project if project.nil?
          parameters = {
            'project' => project
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
